// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title SurplusFallbackRegistry
/// @notice Registry for surplus lots with damay clause, crisis triggers, reservations, and audit trails.
/// @dev No token movement; this is a truth/coordination layer. Integrate payments/escrow off-chain or via separate contracts.
contract SurplusFallbackRegistry {
    // ---------- Roles ----------
    uint8 private constant ROLE_ADMIN   = 1; // can grant/revoke, set triggers, override
    uint8 private constant ROLE_STEWARD = 2; // can register/update lots, bless/quarantine, reserve/consume
    uint8 private constant ROLE_AUDITOR = 4; // can attach audits, read everything

    mapping(address => uint8) private _roles;

    modifier onlyAdmin()   { require(hasRole(msg.sender, ROLE_ADMIN), "Not admin"); _; }
    modifier onlySteward() { require(hasRole(msg.sender, ROLE_STEWARD) || hasRole(msg.sender, ROLE_ADMIN), "Not steward"); _; }
    modifier onlyAuditor() { require(hasRole(msg.sender, ROLE_AUDITOR) || hasRole(msg.sender, ROLE_ADMIN), "Not auditor"); _; }

    function hasRole(address a, uint8 r) public view returns (bool) { return (_roles[a] & r) != 0; }
    function grantRole(address a, uint8 r) external onlyAdmin { _roles[a] |= r; emit RoleGranted(a, r); }
    function revokeRole(address a, uint8 r) external onlyAdmin { _roles[a] &= ~r; emit RoleRevoked(a, r); }

    event RoleGranted(address indexed account, uint8 role);
    event RoleRevoked(address indexed account, uint8 role);

    // ---------- Domain ----------
    enum Quality { C, B, A, S }
    enum Blessing { Unblessed, Blessed, Quarantined }
    enum SourceType { Local, AlliedBarangay, Overseas, Returned, Salvage, Donation }
    enum Status { Active, Reserved, Depleted, Blacklisted, Archived }

    struct SurplusLot {
        uint256 id;
        bytes32 sku;           // normalized identifier
        string description;
        string origin;         // supplier/site/locale
        SourceType sourceType;

        uint256 totalQty;
        uint256 reservedQty;
        uint256 consumedQty;
        bytes32 unit;          // e.g., "kg", "pcs"

        Quality quality;
        Blessing blessing;

        uint256 pricePerUnit;
        bytes32 currency;      // e.g., "PHP", "USD"
        uint64  expiresAt;     // 0 = no expiry

        address owner;         // steward or consignor
        Status  status;

        string[] tags;         // arbitrary labels
        string   proofURI;     // e.g., IPFS batch photos/docs

        uint16 damayBps;       // 0..10000 reserved for community fallback
    }

    uint256 private _nextId = 1;
    mapping(uint256 => SurplusLot) private _lots;
    mapping(bytes32 => uint256[]) private _skuIndex;
    mapping(address => uint256[]) private _ownerIndex;

    // Reservations: lotId => reserver => qty
    mapping(uint256 => mapping(address => uint256)) public reservations;

    // Damay beneficiaries (can consume damay share)
    mapping(address => bool) public damayBeneficiary;

    // Emergency override (allows admin to use damay share)
    bool public globalEmergency;

    // ---------- Triggers ----------
    struct Trigger {
        bool priceSpike;
        bool supplyDisruption;
        bool policyBlockade;
        uint64 until;   // timestamp when trigger expires (0 = indefinite)
        string memo;
    }
    // key: bytes32("GLOBAL") or SKU
    mapping(bytes32 => Trigger) public triggers;
    bytes32 public constant GLOBAL_KEY = keccak256("GLOBAL");

    // ---------- Events ----------
    event LotRegistered(uint256 indexed id, bytes32 indexed sku, address indexed owner);
    event LotUpdated(uint256 indexed id);
    event LotStatusChanged(uint256 indexed id, Status status);
    event LotBlessingChanged(uint256 indexed id, Blessing blessing, string note);
    event PriceUpdated(uint256 indexed id, uint256 pricePerUnit, bytes32 currency);
    event DamayUpdated(uint256 indexed id, uint16 bps);

    event Reserved(uint256 indexed id, address indexed by, uint256 qty, string purpose);
    event Released(uint256 indexed id, address indexed by, uint256 qty, string note);
    event Consumed(uint256 indexed id, address indexed by, uint256 qty, string deliveryRef);

    event TriggerDeclared(bytes32 indexed key, bool priceSpike, bool supplyDisruption, bool policyBlockade, uint64 until, string memo);
    event TriggerCleared(bytes32 indexed key);

    event AuditAttached(uint256 indexed id, string uri, string note);
    event GlobalEmergencySet(bool enabled);
    event DamayBeneficiarySet(address indexed who, bool allowed);

    // ---------- Constructor ----------
    constructor() {
        _roles[msg.sender] = ROLE_ADMIN | ROLE_STEWARD | ROLE_AUDITOR;
        emit RoleGranted(msg.sender, ROLE_ADMIN);
        emit RoleGranted(msg.sender, ROLE_STEWARD);
        emit RoleGranted(msg.sender, ROLE_AUDITOR);
    }

    // ---------- Registration ----------
    struct RegisterParams {
        bytes32 sku;
        string description;
        string origin;
        SourceType sourceType;
        uint256 totalQty;
        bytes32 unit;
        Quality quality;
        uint256 pricePerUnit;
        bytes32 currency;
        uint64  expiresAt;
        string[] tags;
        string proofURI;
        uint16 damayBps; // 0..10000
    }

    function registerLot(RegisterParams calldata p) external onlySteward returns (uint256 id) {
        require(p.totalQty > 0, "totalQty=0");
        require(p.damayBps <= 10000, "damayBps>10000");

        id = _nextId++;
        SurplusLot storage L = _lots[id];
        L.id = id;
        L.sku = p.sku;
        L.description = p.description;
        L.origin = p.origin;
        L.sourceType = p.sourceType;
        L.totalQty = p.totalQty;
        L.unit = p.unit;
        L.quality = p.quality;
        L.blessing = Blessing.Unblessed;
        L.pricePerUnit = p.pricePerUnit;
        L.currency = p.currency;
        L.expiresAt = p.expiresAt;
        L.owner = msg.sender;
        L.status = Status.Active;
        L.proofURI = p.proofURI;
        L.damayBps = p.damayBps;

        for (uint256 i = 0; i < p.tags.length; i++) {
            L.tags.push(p.tags[i]);
        }

        _skuIndex[p.sku].push(id);
        _ownerIndex[msg.sender].push(id);

        emit LotRegistered(id, p.sku, msg.sender);
    }

    // ---------- Updates ----------
    function updatePrice(uint256 id, uint256 pricePerUnit, bytes32 currency) external onlySteward {
        SurplusLot storage L = _onlyOwnerOrAdminLot(id);
        L.pricePerUnit = pricePerUnit;
        L.currency = currency;
        emit PriceUpdated(id, pricePerUnit, currency);
        emit LotUpdated(id);
    }

    function updateQuantity(uint256 id, uint256 newTotalQty) external onlySteward {
        SurplusLot storage L = _onlyOwnerOrAdminLot(id);
        require(newTotalQty >= L.reservedQty + L.consumedQty, "new qty < booked");
        L.totalQty = newTotalQty;
        emit LotUpdated(id);
    }

    function setStatus(uint256 id, Status s) external onlySteward {
        SurplusLot storage L = _onlyOwnerOrAdminLot(id);
        L.status = s;
        emit LotStatusChanged(id, s);
    }

    function setBlessing(uint256 id, Blessing b, string calldata note) external onlySteward {
        SurplusLot storage L = _onlyOwnerOrAdminLot(id);
        L.blessing = b;
        emit LotBlessingChanged(id, b, note);
    }

    function setDamayBps(uint256 id, uint16 bps) external onlySteward {
        require(bps <= 10000, "bps>10000");
        SurplusLot storage L = _onlyOwnerOrAdminLot(id);
        L.damayBps = bps;
        emit DamayUpdated(id, bps);
    }

    function attachAudit(uint256 id, string calldata uri, string calldata note) external onlyAuditor {
        require(_lots[id].id == id, "lot not found");
        emit AuditAttached(id, uri, note);
    }

    // ---------- Reservations ----------
    function reserve(uint256 id, uint256 qty, string calldata purpose) external onlySteward {
        SurplusLot storage L = _requireActive(id);
        require(qty > 0, "qty=0");

        uint256 available = availableQty(id);
        // Enforce damay clause unless caller is beneficiary or emergency is on
        if (!damayBeneficiary[msg.sender] && !globalEmergency) {
            uint256 damayReserve = (L.totalQty * L.damayBps) / 10000;
            require(L.reservedQty + L.consumedQty + qty <= L.totalQty - damayReserve, "damay protected");
        } else {
            require(qty <= available, "insufficient");
        }

        L.reservedQty += qty;
        reservations[id][msg.sender] += qty;

        // If fully reserved, tilt status
        if (L.reservedQty + L.consumedQty == L.totalQty) {
            L.status = Status.Reserved;
            emit LotStatusChanged(id, Status.Reserved);
        }

        emit Reserved(id, msg.sender, qty, purpose);
    }

    function release(uint256 id, uint256 qty, string calldata note) external onlySteward {
        SurplusLot storage L = _requireExists(id);
        uint256 r = reservations[id][msg.sender];
        require(qty > 0 && r >= qty, "bad release");
        reservations[id][msg.sender] = r - qty;
        L.reservedQty -= qty;

        if (L.status == Status.Reserved && L.reservedQty + L.consumedQty < L.totalQty) {
            L.status = Status.Active;
            emit LotStatusChanged(id, Status.Active);
        }

        emit Released(id, msg.sender, qty, note);
    }

    function consume(uint256 id, uint256 qty, string calldata deliveryRef) external onlySteward {
        SurplusLot storage L = _requireExists(id);
        uint256 r = reservations[id][msg.sender];
        require(qty > 0 && r >= qty, "bad consume");

        reservations[id][msg.sender] = r - qty;
        L.reservedQty -= qty;
        L.consumedQty += qty;

        if (L.consumedQty == L.totalQty) {
            L.status = Status.Depleted;
            emit LotStatusChanged(id, Status.Depleted);
        }

        emit Consumed(id, msg.sender, qty, deliveryRef);
    }

    // ---------- Triggers & Damay controls ----------
    function declareTrigger(bytes32 key, bool priceSpike, bool supplyDisruption, bool policyBlockade, uint64 until, string calldata memo) external onlyAdmin {
        Trigger storage T = triggers[key];
        T.priceSpike = priceSpike;
        T.supplyDisruption = supplyDisruption;
        T.policyBlockade = policyBlockade;
        T.until = until;
        T.memo = memo;
        emit TriggerDeclared(key, priceSpike, supplyDisruption, policyBlockade, until, memo);
    }

    function clearTrigger(bytes32 key) external onlyAdmin {
        delete triggers[key];
        emit TriggerCleared(key);
    }

    function setGlobalEmergency(bool enabled) external onlyAdmin {
        globalEmergency = enabled;
        emit GlobalEmergencySet(enabled);
    }

    function setDamayBeneficiary(address who, bool allowed) external onlyAdmin {
        damayBeneficiary[who] = allowed;
        emit DamayBeneficiarySet(who, allowed);
    }

    // ---------- Views ----------
    function getLot(uint256 id) external view returns (SurplusLot memory) {
        require(_lots[id].id == id, "not found");
        return _lots[id];
    }

    function availableQty(uint256 id) public view returns (uint256) {
        SurplusLot storage L = _lots[id];
        require(L.id == id, "not found");
        unchecked {
            uint256 booked = L.reservedQty + L.consumedQty;
            return L.totalQty > booked ? L.totalQty - booked : 0;
        }
    }

    function skuLots(bytes32 sku, uint256 start, uint256 count) external view returns (uint256[] memory ids) {
        uint256[] storage idx = _skuIndex[sku];
        if (start >= idx.length) return new uint256[](0);
        uint256 n = count;
        if (start + n > idx.length) n = idx.length - start;
        ids = new uint256[](n);
        for (uint256 i = 0; i < n; i++) ids[i] = idx[start + i];
    }

    function ownerLots(address owner, uint256 start, uint256 count) external view returns (uint256[] memory ids) {
        uint256[] storage idx = _ownerIndex[owner];
        if (start >= idx.length) return new uint256[](0);
        uint256 n = count;
        if (start + n > idx.length) n = idx.length - start;
        ids = new uint256[](n);
        for (uint256 i = 0; i < n; i++) ids[i] = idx[start + i];
    }

    function isTriggerActive(bytes32 key) public view returns (bool) {
        Trigger storage T = triggers[key];
        if (!T.priceSpike && !T.supplyDisruption && !T.policyBlockade) return false;
        if (T.until == 0) return true;
        return block.timestamp <= T.until;
    }

    // ---------- Internals ----------
    function _onlyOwnerOrAdminLot(uint256 id) internal view returns (SurplusLot storage L) {
        L = _lots[id];
        require(L.id == id, "lot not found");
        if (!hasRole(msg.sender, ROLE_ADMIN)) {
            require(L.owner == msg.sender, "not lot owner");
        }
    }

    function _requireActive(uint256 id) internal view returns (SurplusLot storage L) {
        L = _lots[id];
        require(L.id == id, "lot not found");
        require(L.status == Status.Active || L.status == Status.Reserved, "lot inactive");
    }

    function _requireExists(uint256 id) internal view returns (SurplusLot storage L) {
        L = _lots[id];
        require(L.id == id, "lot not found");
    }
}
