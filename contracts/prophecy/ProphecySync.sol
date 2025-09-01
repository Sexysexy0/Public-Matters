// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract ProphecySync {
    struct Event {
        string title;
        string description;
        string assetID;
        string timestamp;
        uint256 emotionalAPR;
        string broadcastTag;
    }

    Event[] public prophecyEvents;

    event ProphecyBroadcasted(string title, string broadcastTag);

    function broadcastEvent(
        string memory _title,
        string memory _description,
        string memory _assetID,
        string memory _timestamp,
        uint256 _emotionalAPR,
        string memory _broadcastTag
    ) public {
        prophecyEvents.push(Event({
            title: _title,
            description: _description,
            assetID: _assetID,
            timestamp: _timestamp,
            emotionalAPR: _emotionalAPR,
            broadcastTag: _broadcastTag
        }));

        emit ProphecyBroadcasted(_title, _broadcastTag);
    }

    function getEventCount() public view returns (uint256) {
        return prophecyEvents.length;
    }
}
