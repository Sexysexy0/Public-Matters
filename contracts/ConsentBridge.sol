// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract ConsentBridge is Ownable {

    constructor() Ownable(msg.sender) {}

    event ConsentRecord(address user, string setting, string status);

    function logConsent(address user, string memory setting, string memory status) external {
        emit ConsentRecord(user, setting, status);
        // BRIDGE: Consent flows logged for transparency.
    }
}
