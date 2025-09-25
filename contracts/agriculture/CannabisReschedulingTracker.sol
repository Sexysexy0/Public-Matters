// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title CannabisReschedulingTracker
/// @notice Tracks federal cannabis reform milestones and emotional consequence
/// @dev Anchors civic resonance and policy transparency

contract CannabisReschedulingTracker {
    address public steward;
    mapping(address => bool) public policyWatchers;

    modifier onlySteward() {
        require(msg.sender == steward, "Not steward");
        _;
    }

    modifier onlyWatcher() {
        require(policyWatchers[msg.sender] || msg.sender == steward, "Not watcher");
        _;
    }

    struct ReformMilestone {
        uint256 id;
        string title;
        string agency; // e.g., "DEA", "FDA", "Congress"
        string status; // e.g., "Proposed", "In Review", "Passed"
        string emotionalTag;
        uint256 timestamp;
    }

    uint256 public nextMilestoneId = 1;
    mapping(uint256 => ReformMilestone) public milestones;

    event WatcherSet(address indexed account, bool status);
    event MilestoneLogged(uint256 indexed id, string title, string status, string emotionalTag);

    constructor() {
        steward = msg.sender;
        policyWatchers[msg.sender] = true;
        emit WatcherSet(msg.sender, true);
    }

    function setWatcher(address account, bool status) external onlySteward {
        policyWatchers[account] = status;
        emit WatcherSet(account, status);
    }

    function logMilestone(string calldata title, string calldata agency, string calldata status, string calldata emotionalTag) external onlyWatcher returns (uint256 id) {
        id = nextMilestoneId++;
        milestones[id] = ReformMilestone({
            id: id,
            title: title,
            agency: agency,
            status: status,
            emotionalTag: emotionalTag,
            timestamp: block.timestamp
        });
        emit MilestoneLogged(id, title, status, emotionalTag);
    }

    function getMilestone(uint256 id) external view returns (ReformMilestone memory) {
        return milestones[id];
    }
}
