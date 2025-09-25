// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title HempLegislationImpactProtocol
/// @notice Tracks hemp product bans, breach tiers, and supply chain impact
/// @dev Anchors emotional consequence and livelihood corridor defense

contract HempLegislationImpactProtocol {
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

    enum ProductStatus {
        Active,
        Flagged,
        Banned,
        ReformPending
    }

    struct HempProduct {
        uint256 id;
        string name;
        string cannabinoid; // e.g., "Delta-8", "THCP"
        string jurisdiction;
        ProductStatus status;
        string breachTier;
        string emotionalTag;
        uint256 createdAt;
        uint256 updatedAt;
    }

    uint256 public nextProductId = 1;
    mapping(uint256 => HempProduct) public registry;

    event AuditorSet(address indexed account, bool status);
    event ProductFiled(uint256 indexed id, string name, string cannabinoid);
    event ProductFlagged(uint256 indexed id, ProductStatus status, string breachTier, string emotionalTag);

    constructor() {
        steward = msg.sender;
        auditors[msg.sender] = true;
        emit AuditorSet(msg.sender, true);
    }

    function setAuditor(address account, bool status) external onlySteward {
        auditors[account] = status;
        emit AuditorSet(account, status);
    }

    function fileProduct(string calldata name, string calldata cannabinoid, string calldata jurisdiction) external onlyAuditor returns (uint256 id) {
        id = nextProductId++;
        registry[id] = HempProduct({
            id: id,
            name: name,
            cannabinoid: cannabinoid,
            jurisdiction: jurisdiction,
            status: ProductStatus.Active,
            breachTier: "",
            emotionalTag: "",
            createdAt: block.timestamp,
            updatedAt: block.timestamp
        });
        emit ProductFiled(id, name, cannabinoid);
    }

    function flagProduct(uint256 id, ProductStatus status, string calldata breachTier, string calldata emotionalTag) external onlyAuditor {
        HempProduct storage hp = registry[id];
        require(hp.id != 0, "Product not found");
        hp.status = status;
        hp.breachTier = breachTier;
        hp.emotionalTag = emotionalTag;
        hp.updatedAt = block.timestamp;
        emit ProductFlagged(id, status, breachTier, emotionalTag);
    }

    function getProduct(uint256 id) external view returns (HempProduct memory) {
        return registry[id];
    }
}
