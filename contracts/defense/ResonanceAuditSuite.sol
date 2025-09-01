// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract ResonanceAuditSuite {
    struct ResonanceEvent {
        string source;
        string eventType;
        uint256 emotionalAPR;
        uint256 civicImpactScore;
        uint256 timestamp;
        bool flagged;
    }

    ResonanceEvent[] public events;

    event ResonanceLogged(
        string source,
        string eventType,
        uint256 emotionalAPR,
        uint256 civicImpactScore,
        uint256 timestamp,
        bool flagged
    );

    function logResonance(
        string memory _source,
        string memory _eventType,
        uint256 _emotionalAPR,
        uint256 _civicImpactScore
    ) public {
        bool flagged = (_emotionalAPR < 40 || _civicImpactScore > 80);
        uint256 time = block.timestamp;

        events.push(ResonanceEvent(_source, _eventType, _emotionalAPR, _civicImpactScore, time, flagged));
        emit ResonanceLogged(_source, _eventType, _emotionalAPR, _civicImpactScore, time, flagged);
    }

    function getAllEvents() public view returns (ResonanceEvent[] memory) {
        return events;
    }
}
