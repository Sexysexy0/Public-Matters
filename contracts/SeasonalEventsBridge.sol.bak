// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SeasonalEventsBridge {
    struct Event {
        address participant;
        string season;
        uint256 timestamp;
        bool safeguarded;
    }

    Event[] public events;

    event EventLogged(address indexed participant, string season);
    event EventSafeguarded(uint256 indexed id, address verifier);

    function logEvent(string memory _season) public {
        events.push(Event(msg.sender, _season, block.timestamp, false));
        emit EventLogged(msg.sender, _season);
    }

    function safeguardEvent(uint256 _id) public {
        require(_id < events.length, "Invalid ID");
        events[_id].safeguarded = true;
        emit EventSafeguarded(_id, msg.sender);
    }

    function getEvent(uint256 _id) public view returns (Event memory) {
        require(_id < events.length, "Invalid ID");
        return events[_id];
    }

    function totalEvents() public view returns (uint256) {
        return events.length;
    }
}
