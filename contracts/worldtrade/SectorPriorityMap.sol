// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title SectorPriorityMap
/// @notice Maps SKUs or categories to sector type, priority score, and crisis handling rules.
/// @dev Can be linked to SurplusFallbackRegistry for auto-prioritization.
contract SectorPriorityMap {
    enum SectorType { Essential, NonEssential }
    enum Category {
        Tools,
        Machine,
        Lumber,
        Coconut,
        Foods,
        Goods,
        Tech,
        Medical,
        Energy,
        Water,
        Shelter,
        Communication,
        Other
    }

    struct SectorInfo {
        SectorType sectorType;
        Category category;
        uint8 priorityScore; // 1-100, higher = more priority in crisis
        string description;
    }

    address public admin;
    mapping(bytes32 => SectorInfo) public skuMap;       // SKU => info
    mapping(Category => SectorInfo) public categoryMap; // default info per category

    event AdminChanged(address indexed oldAdmin, address indexed newAdmin);
    event SectorInfoSet(bytes32 indexed sku, SectorType sectorType, Category category, uint8 priorityScore, string description);
    event CategoryInfoSet(Category indexed category, SectorType sectorType, uint8 priorityScore, string description);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function setAdmin(address newAdmin) external onlyAdmin {
        require(newAdmin != address(0), "zero addr");
        emit AdminChanged(admin, newAdmin);
        admin = newAdmin;
    }

    /// @notice Set default info for a category
    function setCategoryInfo(Category category, SectorType sectorType, uint8 priorityScore, string calldata description) external onlyAdmin {
        require(priorityScore > 0 && priorityScore <= 100, "invalid score");
        categoryMap[category] = SectorInfo(sectorType, category, priorityScore, description);
        emit CategoryInfoSet(category, sectorType, priorityScore, description);
    }

    /// @notice Set info for a specific SKU (overrides category defaults)
    function setSkuInfo(bytes32 sku, SectorType sectorType, Category category, uint8 priorityScore, string calldata description) external onlyAdmin {
        require(priorityScore > 0 && priorityScore <= 100, "invalid score");
        skuMap[sku] = SectorInfo(sectorType, category, priorityScore, description);
        emit SectorInfoSet(sku, sectorType, category, priorityScore, description);
    }

    /// @notice Get sector info for a SKU, falling back to category defaults
    function getSectorInfo(bytes32 sku, Category category) external view returns (SectorInfo memory) {
        SectorInfo memory info = skuMap[sku];
        if (info.priorityScore == 0) {
            return categoryMap[category];
        }
        return info;
    }

    /// @notice Check if SKU/category is essential
    function isEssential(bytes32 sku, Category category) external view returns (bool) {
        SectorInfo memory info = skuMap[sku];
        if (info.priorityScore == 0) {
            return categoryMap[category].sectorType == SectorType.Essential;
        }
        return info.sectorType == SectorType.Essential;
    }
}
