// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title DebtMigrationCancellationProtocol
/// @notice Cancels unauthorized migration of sovereign debt into stablecoin corridors
/// @dev Anchors breach-tier tagging, emotional consequence, and civic trust restoration

contract DebtMigrationCancellationProtocol {
    address public steward;
    mapping(address => bool) public auditors;

    modifier onlySteward() {
        require(msg.sender == steward, "Not steward");
        _;
    }

    modifier onlyAuditor() {
        require(auditors[msg.sender] || msg.sender == steward, "Not auditor");
        _;
    }

    enum MigrationStatus {
        Proposed,
        Cancelled,
        Approved,
        BreachFlagged
    }

    struct DebtInstrument {
        uint256 id;
        address issuer;
        string currency; // e.g., "USD"
        uint256 amount;
        string corridor; // e.g., "USDT", "DAI", "SyntheticSwap"
        MigrationStatus status;
        string breachTier;
        string emotionalTag;
        uint256 createdAt;
        uint256 updatedAt;
    }

    uint256 public nextDebtId = 1;
    mapping(uint256 => DebtInstrument) public registry;
    mapping(address => uint256[]) public issuerDebts;

    event AuditorSet(address indexed account, bool status);
    event DebtFiled(uint256 indexed id, address indexed issuer, string corridor);
    event MigrationCancelled(uint256 indexed id, string breachTier, string emotionalTag);

    constructor() {
        steward = msg.sender;
        auditors[msg.sender] = true;
        emit AuditorSet(msg.sender, true);
    }

    function setAuditor(address account, bool status) external onlySteward {
        auditors[account] = status;
        emit AuditorSet(account, status);
    }

    function fileDebt(
        address issuer,
        string calldata currency,
        uint256 amount,
        string calldata corridor
    ) external onlyAuditor returns (uint256 id) {
        id = nextDebtId++;
        registry[id] = DebtInstrument({
            id: id,
            issuer: issuer,
            currency: currency,
            amount: amount,
            corridor: corridor,
            status: MigrationStatus.Proposed,
            breachTier: "",
            emotionalTag: "",
            createdAt: block.timestamp,
            updatedAt: block.timestamp
        });
        issuerDebts[issuer].push(id);
        emit DebtFiled(id, issuer, corridor);
    }

    function cancelMigration(uint256 id, string calldata breachTier, string calldata emotionalTag) external onlyAuditor {
        DebtInstrument storage d = registry[id];
        require(d.id != 0, "Debt not found");
        d.status = MigrationStatus.Cancelled;
        d.breachTier = breachTier;
        d.emotionalTag = emotionalTag;
        d.updatedAt = block.timestamp;
        emit MigrationCancelled(id, breachTier, emotionalTag);
    }

    function getDebt(uint256 id) external view returns (DebtInstrument memory) {
        return registry[id];
    }

    function listIssuerDebts(address issuer) external view returns (uint256[] memory) {
        return issuerDebts[issuer];
    }
}
