// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FrontlineEmpathyProtocol {
    struct LeaderRecord {
        string leaderId;
        string name;
        bool hasUndergoneSimulation;
        uint256 empathyScore;
        string lastConflictDeclared;
        uint256 timestamp;
    }

    mapping(string => LeaderRecord) public empathyLedger;

    event EmpathyLogged(string leaderId, string name, bool hasUndergoneSimulation, uint256 empathyScore);

    function logEmpathy(
        string memory leaderId,
        string memory name,
        bool hasUndergoneSimulation,
        uint256 empathyScore,
        string memory lastConflictDeclared
    ) public {
        empathyLedger[leaderId] = LeaderRecord(
            leaderId,
            name,
            hasUndergoneSimulation,
            empathyScore,
            lastConflictDeclared,
            block.timestamp
        );

        emit EmpathyLogged(leaderId, name, hasUndergoneSimulation, empathyScore);
    }

    function getLeaderDetails(string memory leaderId) public view returns (LeaderRecord memory) {
        return empathyLedger[leaderId];
    }
}
