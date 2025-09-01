// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract HealthOracle {
    struct HealthEvent {
        string location;
        string disease;
        uint256 timestamp;
        uint256 severityIndex; // 1–10 scale
        uint256 emotionalAPR;  // 0–100 scale
        bool civicResponseDeployed;
    }

    HealthEvent[] public events;
    address public steward;

    event HealthEventLogged(string location, string disease, uint256 severityIndex, uint256 emotionalAPR);
    event CivicResponseActivated(string location, string disease);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized scrollcaster");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function logHealthEvent(
        string memory _location,
        string memory _disease,
        uint256 _severityIndex,
        uint256 _emotionalAPR
    ) external onlySteward {
        events.push(HealthEvent(_location, _disease, block.timestamp, _severityIndex, _emotionalAPR, false));
        emit HealthEventLogged(_location, _disease, _severityIndex, _emotionalAPR);
    }

    function activateCivicResponse(uint256 _eventId) external onlySteward {
        require(_eventId < events.length, "Invalid event ID");
        events[_eventId].civicResponseDeployed = true;
        emit CivicResponseActivated(events[_eventId].location, events[_eventId].disease);
    }

    function getLatestEvent() external view returns (HealthEvent memory) {
        require(events.length > 0, "No events logged");
        return events[events.length - 1];
    }

    function getEventCount() external view returns (uint256) {
        return events.length;
    }
}
