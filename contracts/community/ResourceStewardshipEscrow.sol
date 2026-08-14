// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ResourceStewardshipEscrow {
    struct ResourceUsage {
        uint256 waterUsed;
        uint256 quota;
        uint256 lastUpdate;
        bool isExceeded;
    }

    mapping(address => ResourceUsage) public usage;
    mapping(address => uint256) public collateralDeposited;

    uint256 public constant WATER_QUOTA = 100_000_000; // 100 million gallons per year
    uint256 public constant PENALTY_PER_UNIT = 1 ether;

    event WaterUsageUpdated(address indexed operator, uint256 usage);
    event CollateralDeposited(address indexed operator, uint256 amount);
    event PenaltyApplied(address indexed operator, uint256 amount);

    function depositCollateral() external payable {
        collateralDeposited[msg.sender] += msg.value;
        emit CollateralDeposited(msg.sender, msg.value);
    }

    function reportWaterUsage(uint256 _usage) external {
        // In production, this would be fed by an oracle (e.g., IoT water meter)
        ResourceUsage storage u = usage[msg.sender];
        u.waterUsed += _usage;
        u.lastUpdate = block.timestamp;

        if (u.waterUsed > WATER_QUOTA) {
            u.isExceeded = true;
            uint256 penalty = (u.waterUsed - WATER_QUOTA) * PENALTY_PER_UNIT / 1e6; // simplified
            if (collateralDeposited[msg.sender] >= penalty) {
                collateralDeposited[msg.sender] -= penalty;
                // Penalty goes to community fund
                emit PenaltyApplied(msg.sender, penalty);
            }
        }
        emit WaterUsageUpdated(msg.sender, _usage);
    }

    function getRemainingQuota(address _operator) external view returns (uint256) {
        ResourceUsage storage u = usage[_operator];
        if (u.waterUsed >= WATER_QUOTA) return 0;
        return WATER_QUOTA - u.waterUsed;
    }
}
