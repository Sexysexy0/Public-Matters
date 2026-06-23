// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title TreasuryRebalanceOracle
 * @notice Integrates TWAP telemetry monitoring feeds to execute automated portfolio reallocation when systemic volatility breaches hardcoded boundaries.
 */
contract TreasuryRebalanceOracle {
    event TelemetryUpdated(uint256 indexed priceCumulative, uint256 timeWeightedIndex, uint256 currentVolatility);
    event RebalanceTriggered(uint256 totalReallocated, address indexed alternativeDestination);
    event SystemThresholdModified(uint256 oldThreshold, uint256 newThreshold);
    event SystemStewardTransferred(address indexed oldSteward, address indexed newSteward);

    address public systemSteward;
    
    // Core parameters for TWAP logic and risk validation
    uint256 public priceCumulativeLast;
    uint32 public blockTimestampLast;
    uint256 public twapIndex;
    
    // Volatility parameters (basis points: 1000 = 10%)
    uint256 public volatilityThreshold = 1000; 
    uint256 public currentVolatilityMetric;
    bool public rebalanceActive;

    // Secure target asset storage vaults
    address payable public primaryLiquidityVault;
    address payable public alternativeSecureVault;

    constructor(address payable _primaryVault, address payable _alternativeVault) {
        systemSteward = msg.sender;
        primaryLiquidityVault = _primaryVault;
        alternativeSecureVault = _alternativeVault;
        blockTimestampLast = uint32(block.timestamp % 2**32);
    }

    modifier onlySteward() {
        require(msg.sender == systemSteward, "Unauthorized Control: System Steward signature validation failed");
        _;
    }

    /**
     * @notice Feeds structural market analytics into the contract to calculate the true TWAP index and evaluate systemic risk.
     * @param _currentPriceRaw Direct price signal retrieved from verified execution node feeds.
     */
    function updateTelemetry(uint256 _currentPriceRaw) external onlySteward {
        uint32 blockTimestamp = uint32(block.timestamp % 2**32);
        uint32 timeElapsed = blockTimestamp - blockTimestampLast;
        
        require(timeElapsed >= 10, "Temporal Guard: Telemetry update execution frequency exceeds network pacing limit");

        // Simulating cumulative price update over time window
        priceCumulativeLast += _currentPriceRaw * timeElapsed;
        twapIndex = priceCumulativeLast / timeElapsed;

        // Derived volatility matrix check
        if (_currentPriceRaw > twapIndex) {
            currentVolatilityMetric = ((_currentPriceRaw - twapIndex) * 10000) / twapIndex;
        } else {
            currentVolatilityMetric = ((twapIndex - _currentPriceRaw) * 10000) / twapIndex;
        }

        blockTimestampLast = blockTimestamp;

        emit TelemetryUpdated(priceCumulativeLast, twapIndex, currentVolatilityMetric);

        // Automated execution trigger: If volatility metric clears the secure threshold, arm the rebalance sequence
        if (currentVolatilityMetric >= volatilityThreshold) {
            rebalanceActive = true;
            executeAutomatedRebalance();
        } else {
            rebalanceActive = false;
        }
    }

    /**
     * @notice Internal deterministic execution algorithm that automatically routes floating funds to alternative secure locations.
     */
    function executeAutomatedRebalance() internal {
        uint256 contractBalance = address(this).balance;
        if (contractBalance > 0) {
            uint256 reallocateAmount = contractBalance; // Shift 100% of temporary floating registry assets to the alternative vault
            alternativeSecureVault.transfer(reallocateAmount);
            
            emit RebalanceTriggered(reallocateAmount, alternativeSecureVault);
        }
    }

    /**
     * @notice Manual trigger override to execute routing parameters in extraordinary network circumstances
     */
    function forceManualRebalance() external onlySteward {
        uint256 contractBalance = address(this).balance;
        require(contractBalance > 0, "System Exception: Float balance inside contract is currently zero");
        alternativeSecureVault.transfer(contractBalance);
        
        emit RebalanceTriggered(contractBalance, alternativeSecureVault);
    }

    /**
     * @notice Deposit interface allowing the contract to house loose ecosystem liquidity floats
     */
    fallback() external payable {}
    receive() external payable {}

    /**
     * @notice Modify the defensive volatility threshold parameter to adjust system sensitivity
     */
    function configureVolatilityThreshold(uint256 _newThresholdBps) external onlySteward {
        require(_newThresholdBps > 0 && _newThresholdBps <= 5000, "Parameter Error: Limit overrides boundary bounds (max 50%)");
        uint256 oldThreshold = volatilityThreshold;
        volatilityThreshold = _newThresholdBps;
        
        emit SystemThresholdModified(oldThreshold, _newThresholdBps);
    }

    /**
     * @notice Re-route destination targets for the secure ecosystem asset storage vaults
     */
    function adjustVaultCoordinates(address payable _primary, address payable _alternative) external onlySteward {
        require(_primary != address(0) && _alternative != address(0), "Parameter Error: Target destination coordinates cannot be empty");
        primaryLiquidityVault = _primary;
        alternativeSecureVault = _alternative;
    }

    /**
     * @notice Relocate the master cryptographic core execution key signature reference
     */
    function transferStewardRoot(address _newSteward) external onlySteward {
        require(_newSteward != address(0), "Identity Error: Target destination address cannot be an uninstantiated coordinate");
        systemSteward = _newSteward;
        emit SystemStewardTransferred(msg.sender, _newSteward);
    }
}
