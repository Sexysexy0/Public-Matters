// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract EventBoard {
    struct Event {
        string title;
        string description;
        uint256 timestamp;
    }

    Event[] public events;

    event EventPosted(uint256 eventId, string title);
    event EventUpdated(uint256 eventId, string title);

    function postEvent(string memory _title, string memory _description) external {
        events.push(Event(_title, _description, block.timestamp));
        emit EventPosted(events.length - 1, _title);
    }

    function updateEvent(uint256 _eventId, string memory _title, string memory _description) external {
        require(_eventId < events.length, "Invalid event");
        events[_eventId].title = _title;
        events[_eventId].description = _description;
        events[_eventId].timestamp = block.timestamp;
        emit EventUpdated(_eventId, _title);
    }

    function getEvent(uint256 _eventId) external view returns (string memory, string memory, uint256) {
        require(_eventId < events.length, "Invalid event");
        Event memory e = events[_eventId];
        return (e.title, e.description, e.timestamp);
    }
}
