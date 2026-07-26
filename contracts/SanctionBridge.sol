// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract SanctionBridge is Ownable {

    constructor() Ownable(msg.sender) {}

    event SanctionRecord(string plaintiff, string sanction);

    function logSanction(string memory plaintiff, string memory sanction) external {
        emit SanctionRecord(plaintiff, sanction);
        // BRIDGE: Sanctions logged to deter abusive litigation.
    }
}
