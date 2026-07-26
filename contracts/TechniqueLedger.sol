// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract TechniqueLedger is Ownable {

    constructor() Ownable(msg.sender) {}

    event TechniqueSeal(string character, string move);

    function logTechnique(string memory _character, string memory _move) external {
        emit TechniqueSeal(_character, _move);
        // RULE: Hidden combat mechanics logged for mastery.
    }
}
