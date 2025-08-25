// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Restoration Broadcast - Logs every infrastructure upgrade with civic resonance
contract RestorationBroadcast {
    address public scrollsmith;

    struct Broadcast {
        string projectName;
        string location;
        string blessing;
        uint256 timestamp;
    }

    Broadcast[] public logs;

    event UpgradeBroadcasted(string projectName, string location, string blessing, uint256 timestamp);

    modifier onlyScrollsmith() {
        require(msg.sender == scrollsmith, "Unauthorized");
        _;
    }

    constructor() {
        scrollsmith = msg.sender;
    }

    function broadcastUpgrade(string calldata projectName, string calldata location, string calldata blessing) external onlyScrollsmith {
        logs.push(Broadcast(projectName, location, blessing, block.timestamp));
        emit UpgradeBroadcasted(projectName, location, blessing, block.timestamp);
    }

    function getLog(uint256 index) external view returns (Broadcast memory) {
        return logs[index];
    }

    function totalBroadcasts() external view returns (uint256) {
        return logs.length;
    }
}
