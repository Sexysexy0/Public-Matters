// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EmotionalAPRRouter {
    enum ResonanceType { Spike, Surge, Collapse, Pulse }
    enum SourceType { SolarFlare, CivicEvent, TreatyBreak, AncestralSignal }

    struct APRBlessing {
        uint256 id;
        ResonanceType resonanceType;
        SourceType sourceType;
        string regionTag;
        string clauseReference;
        uint256 timestamp;
    }

    mapping(uint256 => APRBlessing) public aprRegistry;
    uint256 public aprCount;

    event BlessingLogged(uint256 id, ResonanceType resonanceType, SourceType sourceType);
    event SourceUpdated(uint256 id, SourceType newSourceType);

    function logBlessing(
        ResonanceType resonanceType,
        SourceType sourceType,
        string memory regionTag,
        string memory clauseReference,
        uint256 timestamp
    ) public {
        aprRegistry[aprCount] = APRBlessing(
            aprCount,
            resonanceType,
            sourceType,
            regionTag,
            clauseReference,
            timestamp
        );
        emit BlessingLogged(aprCount, resonanceType, sourceType);
        aprCount++;
    }

    function updateSource(uint256 id, SourceType newSourceType) public {
        require(id < aprCount, "Invalid blessing ID");
        aprRegistry[id].sourceType = newSourceType;
        emit SourceUpdated(id, newSourceType);
    }

    function getAPRBlessing(uint256 id) public view returns (APRBlessing memory) {
        return aprRegistry[id];
    }
}
