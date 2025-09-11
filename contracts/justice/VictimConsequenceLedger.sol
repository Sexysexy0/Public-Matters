// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VictimConsequenceLedger {
    struct Consequence {
        string victimName;
        string incidentSummary;
        uint256 timestamp;
        string judicialActor;
        bool repeatOffender;
        bool verified;
    }

    mapping(uint256 => Consequence) public consequenceLog;
    uint256 public consequenceCount;

    event ConsequenceLogged(uint256 id, string victimName, string judicialActor);

    function logConsequence(
        string memory victimName,
        string memory incidentSummary,
        uint256 timestamp,
        string memory judicialActor,
        bool repeatOffender
    ) public {
        consequenceLog[consequenceCount] = Consequence(
            victimName,
            incidentSummary,
            timestamp,
            judicialActor,
            repeatOffender,
            false
        );
        emit ConsequenceLogged(consequenceCount, victimName, judicialActor);
        consequenceCount++;
    }

    function verifyConsequence(uint256 id) public {
        consequenceLog[id].verified = true;
    }

    function getConsequence(uint256 id) public view returns (Consequence memory) {
        return consequenceLog[id];
    }
}
