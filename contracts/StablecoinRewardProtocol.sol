pragma solidity ^0.8.20;

contract StablecoinRewardProtocol {
    address public admin;

    struct Reward {
        string platform;     // e.g. Coinbase, other exchanges
        uint256 rate;        // interest or reward percentage
        uint256 timestamp;
    }

    Reward[] public rewards;

    event RewardLogged(string platform, uint256 rate, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logReward(string calldata platform, uint256 rate) external onlyAdmin {
        rewards.push(Reward(platform, rate, block.timestamp));
        emit RewardLogged(platform, rate, block.timestamp);
    }

    function totalRewards() external view returns (uint256) {
        return rewards.length;
    }
}
