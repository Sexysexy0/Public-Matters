// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract WhiteWhaleTransparencyReward {
    address public steward;
    address public whale;
    uint256 public rewardAmount;
    string public apologyMessage;
    bool public rewardClaimed;

    event RewardIssued(address indexed whale, uint256 amount, string message);
    event RewardClaimed(address indexed whale);

    modifier onlySteward() {
        require(msg.sender == steward, "Not authorized");
        _;
    }

    modifier onlyWhale() {
        require(msg.sender == whale, "Not the WhiteWhale");
        _;
    }

    constructor(address _whale, uint256 _rewardAmount, string memory _apologyMessage) {
        steward = msg.sender;
        whale = _whale;
        rewardAmount = _rewardAmount;
        apologyMessage = _apologyMessage;
        rewardClaimed = false;
    }

    function issueReward() external onlySteward {
        require(!rewardClaimed, "Already claimed");
        emit RewardIssued(whale, rewardAmount, apologyMessage);
    }

    function claimReward() external onlyWhale {
        require(!rewardClaimed, "Already claimed");
        rewardClaimed = true;
        emit RewardClaimed(whale);
        // Add token transfer logic here if needed
    }

    function getApology() external view returns (string memory) {
        return apologyMessage;
    }
}
