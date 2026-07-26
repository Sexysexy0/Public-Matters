// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract TrainingRegimen is Ownable {

    constructor() Ownable(msg.sender) {}

    mapping(address => uint256) public speedStat;

    // [Goal: Tangible Progression]
    function trainSpeed() external {
        // Logic: Interactive mini-game result affects on-chain stats.
        speedStat[msg.sender] += 1;
        // Result: Better dodging and faster counters in the next fight.
    }
}
