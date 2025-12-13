// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// RewardGuard: record rewards for consistent contributions
contract RewardGuard {
    struct Reward {
        uint256 id;
        address beneficiary;
        string type;       // "Bonus Interest", "Cashback", "Premium Perk"
        uint256 value;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Reward) public rewards;
    mapping(address => bool) public stewards;

    event RewardLogged(uint256 indexed id, address beneficiary, string type, uint256 value);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logReward(address beneficiary, string calldata type, uint256 value) external {
        require(stewards[msg.sender], "Only steward");
        rewards[nextId] = Reward(nextId, beneficiary, type, value, block.timestamp);
        emit RewardLogged(nextId, beneficiary, type, value);
        nextId++;
    }
}
