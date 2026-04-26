// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ConsentBridge {
    event ConsentRecord(address user, string setting, string status);

    function logConsent(address user, string memory setting, string memory status) external {
        emit ConsentRecord(user, setting, status);
        // BRIDGE: Consent flows logged for transparency.
    }
}
