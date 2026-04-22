// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AudienceRetention {
    // [Goal: Build a loyal, sustainable community through action]
    function earnLoyalty(bool _listenedToFeedback) external pure returns (string memory) {
        if (_listenedToFeedback) {
            return "SUCCESS: User sentiment rising. All-time peak reached.";
        }
        return "CRITICAL_FAILURE: Disconnected from audience. System risk high.";
    }
}
