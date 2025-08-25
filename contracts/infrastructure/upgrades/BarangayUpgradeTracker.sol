// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Barangay Upgrade Tracker - Monitors local restoration impact
contract BarangayUpgradeTracker {
    address public scrollsmith;

    struct BarangayLog {
        string barangay;
        string project;
        string category;
        uint256 allocated;
        bool completed;
        uint256 timestamp;
    }

    mapping(uint256 => BarangayLog) public logs;
    uint256 public nextLogId;

    event BarangayLogged(string barangay, string project, string category, uint256 allocated, bool completed);

    modifier onlyScrollsmith() {
        require(msg.sender == scrollsmith, "Unauthorized");
        _;
    }

    constructor() {
        scrollsmith = msg.sender;
    }

    function logUpgrade(
        string calldata barangay,
        string calldata project,
        string calldata category,
        uint256 allocated,
        bool completed
    ) external onlyScrollsmith {
        logs[nextLogId] = BarangayLog(barangay, project, category, allocated, completed, block.timestamp);
        emit BarangayLogged(barangay, project, category, allocated, completed);
        nextLogId++;
    }

    function getLog(uint256 id) external view returns (BarangayLog memory) {
        return logs[id];
    }
}
