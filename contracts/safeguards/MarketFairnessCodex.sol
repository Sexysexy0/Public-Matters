// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title MarketFairnessCodex
/// @notice Safeguard contract to enforce fair market competition, prevent price manipulation, and protect consumer trade dignity
contract MarketFairnessCodex {
    event AssetMetricsAudited(bytes32 indexed assetId, uint256 observedPrice, bool indexed withinFairLimits);
    event FairPricingThresholdUpdated(bytes32 indexed assetId, uint256 maxDeviationAllowed);
    event MarketAnomalyFlagged(address indexed suspiciousTrader, string infractionType, uint256 impactScore);
    event MarketAuthorityTransferred(address indexed previousSteward, address indexed newSteward);

    address public marketSteward;
    bool public strictFairnessEnforcement;

    struct MarketAssetProfile {
        bool isMonitored;
        uint256 referencePrice; // Anchored fair market baseline price token
        uint256 maxDeviationBps; // Max deviation allowed in Basis Points (e.g., 500 = 5%)
        uint256 lastAuditTimestamp;
    }

    // Mapping from unique asset identifier hash to its structural market parameters
    mapping(bytes32 => MarketAssetProfile) public marketRegistry;
    // Track known front-running bots or high-risk systemic manipulation accounts
    mapping(address => bool) public blacklistedEntities;

    constructor() {
        marketSteward = msg.sender;
        strictFairnessEnforcement = true;
    }

    modifier onlySteward() {
        require(msg.sender == marketSteward, "Unauthorized: Market Steward clearance required");
        _;
    }

    /// @notice Register a core asset or commodity into the market monitoring registry
    /// @param _assetId Cryptographic identifier hash of the audited asset
    /// @param _initialRefPrice Foundational fair market price baseline
    /// @param _deviationLimit Maximum permissible variance in basis points
    function registerMarketAsset(
        bytes32 _assetId,
        uint256 _initialRefPrice,
        uint256 _deviationLimit
    ) external onlySteward {
        require(_assetId != bytes32(0), "Invalid asset profile hash");
        require(!marketRegistry[_assetId].isMonitored, "Asset signature already active in registry");
        require(_deviationLimit <= 10000, "Deviation limit cannot exceed absolute scale (100%)");

        marketRegistry[_assetId] = MarketAssetProfile({
            isMonitored: true,
            referencePrice: _initialRefPrice,
            maxDeviationBps: _deviationLimit,
            lastAuditTimestamp: block.timestamp
        });

        emit FairPricingThresholdUpdated(_assetId, _deviationLimit);
    }

    /// @notice Audit and log real-time asset trade execution data to detect systemic flash manipulation
    /// @param _assetId Cryptographic identity string of the analyzed asset profile
    /// @param _executionPrice The real-time price recorded during the trade block
    /// @param _trader The address of the entity executing the trade
    function auditTradeExecution(
        bytes32 _assetId,
        uint256 _executionPrice,
        address _trader
    ) external {
        MarketAssetProfile storage asset = marketRegistry[_assetId];
        require(asset.isMonitored, "Target asset registry instance profile not active");
        require(!blacklistedEntities[_trader], "Access Denied: Trader node is restricted due to fairness violation");

        uint256 absoluteDiff = _executionPrice > asset.referencePrice 
            ? _executionPrice - asset.referencePrice 
            : asset.referencePrice - _executionPrice;
        
        uint256 deviationBps = (absoluteDiff * 10000) / asset.referencePrice;

        if (strictFairnessEnforcement && deviationBps > asset.maxDeviationBps) {
            emit MarketAnomalyFlagged(_trader, "Breach: Excessive price deviation or artificial slippage detected", deviationBps);
            // If threat profile is high-risk, freeze execution clearance by returning false validation states
        }

        asset.lastAuditTimestamp = block.timestamp;
        emit AssetMetricsAudited(_assetId, _executionPrice, deviationBps <= asset.maxDeviationBps);
    }

    /// @notice Calibrate and update the baseline fair reference price to reflect real supply-demand anchors
    function updateReferencePrice(bytes32 _assetId, uint256 _newRefPrice) external onlySteward {
        require(marketRegistry[_assetId].isMonitored, "Target market asset not found");
        marketRegistry[_assetId].referencePrice = _newRefPrice;
    }

    /// @notice Ban malicious trading nodes, MEV bots, or insider coordination clusters
    function flagManipulativeEntity(address _entity, bool _restrictStatus) external onlySteward {
        require(_entity != address(0), "Invalid entity coordinates");
        blacklistedEntities[_entity] = _restrictStatus;
    }

    /// @notice Upgrade or migrate the central Market Steward execution architecture
    function transferMarketAuthority(address _newSteward) external onlySteward {
        require(_newSteward != address(0), "Invalid upgrade destination coordinates");
        emit MarketAuthorityTransferred(marketSteward, _newSteward);
        marketSteward = _newSteward;
    }
}
