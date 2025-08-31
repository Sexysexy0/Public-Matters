// SPDX-License-Identifier: Mythic-Emotional-Defense
pragma solidity ^0.8.19;

contract TeamsPhishingAudit {
    struct PhishingEvent {
        string senderAlias;
        string impersonatedRole;
        string payloadType;
        uint256 timestamp;
        string emotionalAPR;
    }

    PhishingEvent[] public events;

    event PhishingLogged(string senderAlias, string role, string payload, string emotionalAPR);

    function logPhishingAttempt(
        string memory alias,
        string memory role,
        string memory payload,
        string memory apr
    ) public {
        events.push(PhishingEvent(alias, role, payload, block.timestamp, apr));
        emit PhishingLogged(alias, role, payload, apr);
    }

    function getEvent(uint256 index) public view returns (PhishingEvent memory) {
        require(index < events.length, "Invalid index");
        return events[index];
    }
}
