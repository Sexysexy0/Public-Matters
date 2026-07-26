// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract SailingOracle is Ownable {

    constructor() Ownable(msg.sender) {}

    event SailingRecord(string ship, string status);

    function logSailing(string memory ship, string memory status) external {
        emit SailingRecord(ship, status);
        // ORACLE: Sailing expansion monitored for Crimson Desert.
    }
}
