// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

contract BitMarketGlobalSignalSanctifier {
    address public steward;
    uint public integrityThreshold = 90;

    event SignalValidated(string origin, string destination, bool isAllowed, string reason);
    event FirewallAlert(string origin, string reason, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function validateSignal(string memory origin, string memory destination, uint aprScore) public {
        bool isAllowed = aprScore >= integrityThreshold;
        string memory reason = isAllowed ? "Signal integrity confirmed" : "APR breach — signal blocked";
        emit SignalValidated(origin, destination, isAllowed, reason);
        if (!isAllowed) {
            emit FirewallAlert(origin, reason, block.timestamp);
        }
    }

    function updateThreshold(uint newThreshold) public {
        require(msg.sender == steward, "Only steward may update threshold");
        integrityThreshold = newThreshold;
    }
}
