// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title HardwarePriceCeiling
 * @notice Anti-monopoly infrastructure engineered to penalize semiconductor manufacturers (e.g., Micron cartel) exploiting artificial supply crunches to inflate chip prices.
 */
contract HardwarePriceCeiling {
    event PriceCeilingEnforced(string indexed hardwareType, uint256 maxPriceWei, uint256 currentMargin);
    event ManufacturerSanctioned(address indexed manufacturerNode, string reason);
    event ConsumerRebateTriggered(address indexed buyer, uint256 refundAmount);

    address public marketArbiter;
    uint256 public constant MAX_PERMISSIBLE_MARGIN = 40; // 40% maximum premium (dudurog sa 84% predatory margins)

    struct ProductMetrics {
        uint256 baseProductionCost;
        uint256 currentMarketPrice;
        bool isRegulated;
        bool structuralViolation;
    }

    // Map hardware identifiers (e.g., Keccak of "DDR5_HBM") to market matrices
    mapping(bytes32 => ProductMetrics) public priceIndexGrid;
    // Track bad actor nodes (manufacturers who prioritize data centers over fair retail)
    mapping(address => bool) public blacklistedSuppliers;

    constructor() {
        marketArbiter = msg.sender;
    }

    modifier onlyArbiter() {
        require(msg.sender == marketArbiter, "Access Denied: Market regulator signature validation fail");
        _;
    }

    /**
     * @notice Sets base operational metrics for computing real production vs market cost telemetry.
     */
    function registerHardwareMetric(
        bytes32 _hardwareId,
        uint256 _baseCost,
        uint256 _marketPrice,
        string calldata _label
    ) external onlyArbiter {
        uint256 computedMargin = ((_marketPrice - _baseCost) * 100) / _baseCost;
        bool violation = computedMargin > MAX_PERMISSIBLE_MARGIN;

        priceIndexGrid[_hardwareId] = ProductMetrics({
            baseProductionCost: _baseCost,
            currentMarketPrice: _marketPrice,
            isRegulated: true,
            structuralViolation: violation
        });

        emit PriceCeilingEnforced(_label, _marketPrice, computedMargin);
    }

    /**
     * @notice Blacklists wholesale corporate suppliers who execute long-term predatory data center capacity lock-ins.
     */
    function penalizeSupplierCartel(address _supplier, string calldata _reason) external onlyArbiter {
        require(_supplier != address(0), "Parameter Error: Invalid node coordinate");
        blacklistedSuppliers[_supplier] = true;
        emit ManufacturerSanctioned(_supplier, _reason);
    }
}
