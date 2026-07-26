// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract OptionalResortBridge is Ownable {

    constructor() Ownable(msg.sender) {}

    event ResortRecord(string visitor, string choice);

    function logResort(string memory visitor, string memory choice) external {
        emit ResortRecord(visitor, choice);
        // BRIDGE: Resort access logged to safeguard freedom of choice and prevent exploitative mandatory fees.
    }
}
