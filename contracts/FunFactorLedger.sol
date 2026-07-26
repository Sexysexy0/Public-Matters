// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract FunFactorLedger is Ownable {

    constructor() Ownable(msg.sender) {}

    event EngagementSeal(string mode, string feedback);

    function logFeedback(string memory _mode, string memory _feedback) external {
        emit EngagementSeal(_mode, _feedback);
        // LEDGER: Fun factor tracked and flagged.
    }
}
