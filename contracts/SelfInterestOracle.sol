// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract SelfInterestOracle is Ownable {

    constructor() Ownable(msg.sender) {}

    event BiasRecord(string actor, string bias);

    function logBias(string memory actor, string memory bias) external {
        emit BiasRecord(actor, bias);
        // ORACLE: Self-interest bias monitored to safeguard collective governance.
    }
}
