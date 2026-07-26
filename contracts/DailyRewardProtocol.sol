// DailyRewardProtocol.sol
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract DailyRewardProtocol is Ownable {

    constructor() Ownable(msg.sender) {}

    mapping(address => uint256) public rewards;

    event RewardTopUp(address indexed worker, uint256 amount);

    function topUpDaily(address worker, uint256 amount) public {
        rewards[worker] += amount;
        emit RewardTopUp(worker, amount);
    }
}
