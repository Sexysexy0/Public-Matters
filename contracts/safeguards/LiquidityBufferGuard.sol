// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title LiquidityBufferGuard
 * @notice Enforces liquidity retention floors and dynamic withdrawal friction parameters to safeguard network assets from flash asset exits.
 */
contract LiquidityBufferGuard {
    event LiquidityDeposited(address indexed investor, uint256 amount);
    event AssetWithdrawn(address indexed investor, uint256 grossAmount, uint256 penaltyFee);
    event LiquidityFloorModified(uint256 oldFloor, uint256 newFloor);

    address public managerSteward;
    uint256 public liquidityFloorLimit; // Minimum total pool size that must stay locked inside memory registers
    uint256 public totalBufferedLiquidity;
    
    uint256 public constant CRITICAL_FRICTION_BPS = 1500; // 15% exit penalty enforced during high-volatility or run-on-pool alerts
    bool public emergencyFrictionActive;

    mapping(address => uint256) public userBalances;

    constructor(uint256 _initialFloorWei) {
        managerSteward = msg.sender;
        liquidityFloorLimit = _initialFloorWei;
    }

    modifier onlyManager() {
        require(msg.sender == managerSteward, "Access Denied: Owner token validation failure");
        _;
    }

    /// @notice Process incoming capital entries into the secure liquidity buffer system
    function depositLiquidity() external payable {
        require(msg.value > 0, "Processing Exception: Deposit allocation weight must exceed zero");
        userBalances[msg.sender] += msg.value;
        totalBufferedLiquidity += msg.value;

        emit LiquidityDeposited(msg.sender, msg.value);
    }

    /**
     * @notice Secure withdrawal pathway checking structural buffer depth constraints to block overnight asset drains.
     */
    function withdrawLiquidity(uint256 _requestedAmount) external {
        require(userBalances[msg.sender] >= _requestedAmount, "Balance Exception: Requested weight exceeds account allocation registries");
        
        uint256 systemicRemainder = totalBufferedLiquidity - _requestedAmount;
        
        // Safety Guard Gate: If the withdrawal forces the asset depth below the structural limit, activate friction defenses
        uint256 operationalPenalty = 0;
        if (systemicRemainder < liquidityFloorLimit || emergencyFrictionActive) {
            operationalPenalty = (_requestedAmount * CRITICAL_FRICTION_BPS) / 10000;
        }

        uint256 netPayout = _requestedAmount - operationalPenalty;
        userBalances[msg.sender] -= _requestedAmount;
        totalBufferedLiquidity -= _requestedAmount;

        payable(msg.sender).transfer(netPayout);
        if (operationalPenalty > 0) {
            payable(managerSteward).transfer(operationalPenalty); // Send penalty friction buffer to the management core
        }

        emit AssetWithdrawn(msg.sender, _requestedAmount, operationalPenalty);
    }

    /// @notice Toggle manual panic run-on-pool friction constraints
    function toggleEmergencyFriction(bool _status) external onlyManager {
        emergencyFrictionActive = _status;
    }

    /// @notice Modify the minimum required structural assets floor limit parameter
    function adjustLiquidityFloor(uint256 _newFloorWei) external onlyManager {
        uint256 oldFloor = liquidityFloorLimit;
        liquidityFloorLimit = _newFloorWei;

        emit LiquidityFloorModified(oldFloor, _newFloorWei);
    }
}
