// PlayToEarnCatalyst.sol
pragma solidity ^0.8.0;

contract PlayToEarnCatalyst {
    struct Reward {
        uint256 id;
        address player;
        string activity;   // e.g. "Battle", "Quest", "NFT Trade"
        uint256 amount;
        uint256 timestamp;
    }

    uint256 public rewardCount;
    mapping(uint256 => Reward) public rewards;

    event RewardIssued(uint256 id, address player, string activity, uint256 amount, uint256 timestamp);
    event CatalystDeclared(string message);

    function issueReward(address player, string memory activity, uint256 amount) public {
        rewardCount++;
        rewards[rewardCount] = Reward(rewardCount, player, activity, amount, block.timestamp);
        emit RewardIssued(rewardCount, player, activity, amount, block.timestamp);
    }

    function declareCatalyst() public {
        emit CatalystDeclared("Play-to-Earn Catalyst: Gaming incentives and NFT rewards igniting crypto adoption.");
    }
}
