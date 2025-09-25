// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title BotnetTracker
/// @notice Tracks botnet infections, breach vectors, and device types
/// @dev Anchors firmware audit and emotional consequence mapping

contract BotnetTracker {
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

    struct BotnetEvent {
        uint256 id;
        string name; // e.g., "AISURU"
        string vector; // e.g., "Totolink firmware", "Realtek chip"
        string deviceType; // e.g., "IP Camera", "Router", "DVR"
        string emotionalTag;
        uint256 timestamp;
    }

    uint256 public nextEventId = 1;
    mapping(uint256 => BotnetEvent) public events;

    event WatcherSet(address indexed account, bool status);
    event BotnetLogged(uint256 indexed id, string name, string vector, string emotionalTag);

    constructor() {
        steward = msg.sender;
        watchers[msg.sender] = true;
        emit WatcherSet(msg.sender, true);
    }

    function setWatcher(address account, bool status) external onlySteward {
        watchers[account] = status;
        emit WatcherSet(account, status);
    }

    function logBotnet(
        string calldata name,
        string calldata vector,
        string calldata deviceType,
        string calldata emotionalTag
    ) external onlyWatcher returns (uint256 id) {
        id = nextEventId++;
        events[id] = BotnetEvent({
            id: id,
            name: name,
            vector: vector,
            deviceType: deviceType,
            emotionalTag: emotionalTag,
            timestamp: block.timestamp
        });
        emit BotnetLogged(id, name, vector, emotionalTag);
    }

    function getEvent(uint256 id) external view returns (BotnetEvent memory) {
        return events[id];
    }
}
