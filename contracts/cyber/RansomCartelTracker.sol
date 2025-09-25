// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title RansomCartelTracker
/// @notice Tracks ransomware cartel activity, tactics, and breach-tier tagging
/// @dev Anchors forensic audit and emotional consequence mapping

contract RansomCartelTracker {
    address public steward;
    mapping(address => bool) public watchers;

    modifier onlySteward() {
        require(msg.sender == steward, "Not steward");
        _;
    }

    modifier onlyWatcher() {
        require(watchers[msg.sender] || msg.sender == steward, "Not watcher");
        _;
    }

    struct CartelActivity {
        uint256 id;
        string name; // e.g., "Play", "ALPHV", "DarkBit"
        string tactic; // e.g., "Intermittent Encryption", "Double Extortion"
        string breachTier;
        string emotionalTag;
        uint256 timestamp;
    }

    uint256 public nextActivityId = 1;
    mapping(uint256 => CartelActivity) public activities;

    event WatcherSet(address indexed account, bool status);
    event CartelLogged(uint256 indexed id, string name, string tactic, string breachTier, string emotionalTag);

    constructor() {
        steward = msg.sender;
        watchers[msg.sender] = true;
        emit WatcherSet(msg.sender, true);
    }

    function setWatcher(address account, bool status) external onlySteward {
        watchers[account] = status;
        emit WatcherSet(account, status);
    }

    function logCartel(string calldata name, string calldata tactic, string calldata breachTier, string calldata emotionalTag) external onlyWatcher returns (uint256 id) {
        id = nextActivityId++;
        activities[id] = CartelActivity({
            id: id,
            name: name,
            tactic: tactic,
            breachTier: breachTier,
            emotionalTag: emotionalTag,
            timestamp: block.timestamp
        });
        emit CartelLogged(id, name, tactic, breachTier, emotionalTag);
    }

    function getActivity(uint256 id) external view returns (CartelActivity memory) {
        return activities[id];
    }
}
