// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title FusionOperatingLayer
 * @notice Centralized data integrity layer designed for PH e-commerce operations to bridge inventory desynchronization and eliminate chaos caused by multi-channel oversells during high-velocity peak promo days.
 */
contract FusionOperatingLayer {
    event StockSynchronized(string indexed sku, uint256 absoluteStock, uint256 reservedBuffer);
    event OrderDispatched(string indexed sku, uint256 quantity, address indexed channelNode);
    event OversellIntercepted(string indexed sku, uint256 requestedQty, uint256 availableQty, address indexed channelNode);
    event SystemStewardUpdated(address indexed newSteward);

    address public operatingSteward;
    uint256 public totalChannelsTracked;
    uint256 public totalInterceptedOversells;

    struct InventoryState {
        uint256 globalStockPool;
        uint256 safetyBufferThreshold; // Emergency stock reserve to cushion latency delays across channels (Lazada, Shopee, TikTok Shop, Web)
        uint256 lastSyncBlock;
        bool activeTracking;
    }

    // Master operational grid maps product SKUs to their unified real-time inventory states
    mapping(string => InventoryState) public globalInventoryRegistry;
    // Map of authorized fulfillment centers, channel connectors, and execution nodes
    mapping(address => bool) public authorizedOperatingNodes;

    constructor() {
        operatingSteward = msg.sender;
        authorizedOperatingNodes[msg.sender] = true;
    }

    modifier onlySteward() {
        require(msg.sender == operatingSteward, "Access Denied: Operating steward signature validation fail");
        _;
    }

    modifier onlyOperatingNode() {
        require(authorizedOperatingNodes[msg.sender], "Access Denied: Caller node is not an authorized operating channel");
        _;
    }

    /**
     * @notice Provisions or updates authorization codes for specialized ERP systems or done-for-you execution teams.
     */
    function configureOperatingNode(address _node, bool _status) external onlySteward {
        require(_node != address(0), "Parameter Error: Target infrastructure node cannot be blank");
        authorizedOperatingNodes[_node] = _status;
        if(_status) {
            totalChannelsTracked += 1;
        } else {
            totalChannelsTracked -= 1;
        }
    }

    /**
     * @notice Forces absolute synchronization of a specific SKU's global inventory across all localized storage nodes.
     */
    function synchronizeGlobalStock(
        string calldata _sku, 
        uint256 _absoluteStock, 
        uint256 _buffer
    ) external onlyOperatingNode {
        bytes memory skuCheck = bytes(_sku);
        require(skuCheck.length > 0, "Parameter Error: Stock Keeping Unit (SKU) coordinate identifier cannot be empty");
        require(_absoluteStock >= _buffer, "Validation Error: Global stock pool cannot be lesser than the safety buffer baseline");

        globalInventoryRegistry[_sku] = InventoryState({
            globalStockPool: _absoluteStock,
            safetyBufferThreshold: _buffer,
            lastSyncBlock: block.number,
            activeTracking: true
        });

        emit StockSynchronized(_sku, _absoluteStock, _buffer);
    }

    /**
     * @notice High-speed transaction routing gateway that verifies and processes multi-channel product orders in real-time.
     * @dev Acts as an unerasable firewall that blocks transaction routing the exact moment an oversell condition threatens operational stability.
     */
    function routeChannelOrder(string calldata _sku, uint256 _requestedQuantity) external onlyOperatingNode {
        InventoryState storage stock = globalInventoryRegistry[_sku];
        require(stock.activeTracking, "Operational Exception: Targeted SKU trace is not registered in the Fusion layer");

        // Calculate maximum available stock that can be safely sold without cutting into the buffer matrix
        uint256 safelyAllocatedStock = stock.globalStockPool - stock.safetyBufferThreshold;

        if (_requestedQuantity > safelyAllocatedStock) {
            totalInterceptedOversells += 1;
            emit OversellIntercepted(_sku, _requestedQuantity, stock.globalStockPool, msg.sender);
            revert("FUSION_INTERCEPT: Operational lock active. Insufficient verified inventory pool to execute order safe route.");
        }

        // Deduct quantity immediately upon verification to prevent concurrent race condition exploits (double-spending inventory)
        stock.globalStockPool -= _requestedQuantity;
        
        emit OrderDispatched(_sku, _requestedQuantity, msg.sender);
    }

    /**
     * @notice External view enabling storefront components to scan real-time absolute data visibility before pushing customer orders.
     */
    function getSkuTelemetry(string calldata _sku) external view returns (uint256, uint256, uint256, bool) {
        InventoryState storage stock = globalInventoryRegistry[_sku];
        return (stock.globalStockPool, stock.safetyBufferThreshold, stock.lastSyncBlock, stock.isLocked(stock.globalStockPool));
    }
}

// Extension to cleanly handle internal safety state validations
library SafeOperationExtension {
    function isLocked(FusionOperatingLayer.InventoryState storage stock, uint256 currentPool) internal view returns (bool) {
        return currentPool <= stock.safetyBufferThreshold;
    }
}

