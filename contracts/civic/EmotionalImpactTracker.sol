// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.19;

contract EmotionalImpactTracker {
    address public steward;

    struct ImpactLog {
        string subject;
        string type; // "Build", "Blessing", "Broadcast", etc.
        uint256 empathyScore;
        uint256 trustScore;
        uint256 mythicClarity;
        string communityFeedback;
        uint256 timestamp;
    }

    ImpactLog[] public logs;

    event ImpactLogged(string subject, string type, uint256 empathyScore, uint256 trustScore);

    constructor() {
        steward = msg.sender;
    }

    function logImpact(
        string memory subject,
        string memory type,
        uint256 empathyScore,
        uint256 trustScore,
        uint256 mythicClarity,
        string memory communityFeedback
    ) public {
        logs.push(ImpactLog(subject, type, empathyScore, trustScore, mythicClarity, communityFeedback, block.timestamp));
        emit ImpactLogged(subject, type, empathyScore, trustScore);
    }

    function getImpactLog(uint256 index) public view returns (ImpactLog memory) {
        return logs[index];
    }

    function totalLogs() public view returns (uint256) {
        return logs.length;
    }
}
