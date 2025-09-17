// SPDX-License-Identifier: DigitalSanctum
pragma solidity ^0.8.19;

contract HateSpeechSanctifier {
    address public steward;

    struct Incident {
        string perpetrator;
        string platform;
        string statement;
        string targetGroup;
        uint256 timestamp;
        bool verified;
    }

    Incident[] public incidents;

    event HateSpeechLogged(string perpetrator, string platform, string targetGroup, uint256 timestamp);
    event IncidentVerified(uint256 index, address verifier);

    constructor() {
        steward = msg.sender;
    }

    function logIncident(
        string memory perpetrator,
        string memory platform,
        string memory statement,
        string memory targetGroup
    ) public {
        incidents.push(Incident(perpetrator, platform, statement, targetGroup, block.timestamp, false));
        emit HateSpeechLogged(perpetrator, platform, targetGroup, block.timestamp);
    }

    function verifyIncident(uint256 index) public {
        require(index < incidents.length, "Invalid index");
        incidents[index].verified = true;
        emit IncidentVerified(index, msg.sender);
    }

    function getIncident(uint256 index) public view returns (string memory, string memory, string memory, string memory, uint256, bool) {
        Incident memory i = incidents[index];
        return (i.perpetrator, i.platform, i.statement, i.targetGroup, i.timestamp, i.verified);
    }

    function totalIncidents() public view returns (uint256) {
        return incidents.length;
    }
}
