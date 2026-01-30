// DailyRewardProtocol.sol
pragma solidity ^0.8.0;

contract DailyRewardProtocol {
    mapping(address => uint256) public rewards;

    event RewardTopUp(address indexed worker, uint256 amount);

    function topUpDaily(address worker, uint256 amount) public {
        rewards[worker] += amount;
        emit RewardTopUp(worker, amount);
    }
}
