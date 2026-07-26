// HarvestIncentiveProtocol.sol
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract HarvestIncentiveProtocol is Ownable {

    constructor() Ownable(msg.sender) {}

    mapping(address => uint256) public incentives;

    event IncentiveHarvest(address indexed worker, uint256 amount);

    function harvestTwiceMonthly(address worker, uint256 amount) public {
        incentives[worker] += amount;
        emit IncentiveHarvest(worker, amount);
    }
}
