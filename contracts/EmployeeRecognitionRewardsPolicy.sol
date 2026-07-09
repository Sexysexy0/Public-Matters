// SPDX-License-Identifier: MIT
// Contract Name: EmployeeRecognitionRewardsPolicy
// Purpose: Establish recognition and rewards system for employees
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract EmployeeRecognitionRewardsPolicy {
    address public chiefOperator;
    uint256 public rewardCount;

    struct Reward {
        string principle;
        string rewardMechanism;
        uint256 timestamp;
    }

    Reward[] public rewards;

    event RewardAdded(string principle, string rewardMechanism, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        rewardCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Add new recognition/reward clause
    function addReward(string memory principle, string memory rewardMechanism) public onlyChief {
        rewards.push(Reward(principle, rewardMechanism, block.timestamp));
        rewardCount++;
        emit RewardAdded(principle, rewardMechanism, block.timestamp);
    }

    // View recognition/reward clause details
    function getReward(uint256 index) public view returns (string memory, string memory, uint256) {
        require(index < rewards.length, "Invalid reward index");
        Reward memory r = rewards[index];
        return (r.principle, r.rewardMechanism, r.timestamp);
    }
}
