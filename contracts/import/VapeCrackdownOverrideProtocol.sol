// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title VapeCrackdownOverrideProtocol
/// @notice Cancels or overrides vape product crackdowns based on dignity, livelihood, and treaty-grade import ethics
/// @dev Anchors breach-tier tagging, emotional consequence, and civic restraint broadcasting

contract VapeCrackdownOverrideProtocol {
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

    enum CrackdownStatus {
        Proposed,
        Blocked,
        Approved,
        BreachFlagged
    }

    struct VapeProduct {
        uint256 id;
        address importer;
        string origin; // e.g., "China"
        string brand;
        string composition; // e.g., "Nicotine 3mg", "Flavor: Mango Ice"
        CrackdownStatus status;
        string breachTier;
        string emotionalTag;
        uint256 createdAt;
        uint256 updatedAt;
    }

    uint256 public nextProductId = 1;
    mapping(uint256 => VapeProduct) public registry;
    mapping(address => uint256[]) public importerProducts;

    event AuditorSet(address indexed account, bool status);
    event VapeFiled(uint256 indexed id, address indexed importer, string brand);
    event CrackdownBlocked(uint256 indexed id, string breachTier, string emotionalTag);

    constructor() {
        steward = msg.sender;
        auditors[msg.sender] = true;
        emit AuditorSet(msg.sender, true);
    }

    function setAuditor(address account, bool status) external onlySteward {
        auditors[account] = status;
        emit AuditorSet(account, status);
    }

    function fileVapeProduct(
        address importer,
        string calldata origin,
        string calldata brand,
        string calldata composition
    ) external onlyAuditor returns (uint256 id) {
        id = nextProductId++;
        registry[id] = VapeProduct({
            id: id,
            importer: importer,
            origin: origin,
            brand: brand,
            composition: composition,
            status: CrackdownStatus.Proposed,
            breachTier: "",
            emotionalTag: "",
            createdAt: block.timestamp,
            updatedAt: block.timestamp
        });
        importerProducts[importer].push(id);
        emit VapeFiled(id, importer, brand);
    }

    function blockCrackdown(uint256 id, string calldata breachTier, string calldata emotionalTag) external onlyAuditor {
        VapeProduct storage vp = registry[id];
        require(vp.id != 0, "Product not found");
        vp.status = CrackdownStatus.Blocked;
        vp.breachTier = breachTier;
        vp.emotionalTag = emotionalTag;
        vp.updatedAt = block.timestamp;
        emit CrackdownBlocked(id, breachTier, emotionalTag);
    }

    function getVapeProduct(uint256 id) external view returns (VapeProduct memory) {
        return registry[id];
    }

    function listImporterProducts(address importer) external view returns (uint256[] memory) {
        return importerProducts[importer];
    }
}
