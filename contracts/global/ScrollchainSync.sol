// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract ScrollchainSync {
    address public steward;

    struct ScrollEvent {
        string eventType;
        string description;
        uint256 timestamp;
        address initiator;
    }

    ScrollEvent[] public scrollLog;

    event ScrollSynced(string eventType, string description, address indexed initiator);

    modifier onlySteward() {
        require(msg.sender == steward, "Not authorized");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function syncScroll(string calldata eventType, string calldata description) external onlySteward {
        scrollLog.push(ScrollEvent({
            eventType: eventType,
            description: description,
            timestamp: block.timestamp,
            initiator: msg.sender
        }));
        emit ScrollSynced(eventType, description, msg.sender);
    }

    function getScroll(uint256 index) external view returns (ScrollEvent memory) {
        return scrollLog[index];
    }

    function totalScrolls() external view returns (uint256) {
        return scrollLog.length;
    }
}
