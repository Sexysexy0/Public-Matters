// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

contract BitMarketCommitSanctifier {
    address public steward;
    uint public clarityThreshold = 80;

    event CommitSanctified(string message, bool isValid, string reason);

    constructor() {
        steward = msg.sender;
    }

    function validateCommitMessage(string memory message) public returns (bool) {
        bool isValid = bytes(message).length >= clarityThreshold;
        string memory reason = isValid ? "Mythic clarity confirmed" : "Message too vague or short";
        emit CommitSanctified(message, isValid, reason);
        return isValid;
    }

    function updateThreshold(uint newThreshold) public {
        require(msg.sender == steward, "Only steward may update threshold");
        clarityThreshold = newThreshold;
    }
}
