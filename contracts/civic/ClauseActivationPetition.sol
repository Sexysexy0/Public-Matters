// SPDX-License-Identifier: ClauseActivationPetition-License
pragma solidity ^0.8.0;

contract ClauseActivationPetition {
    address public steward;

    struct PetitionSignal {
        string clauseID;
        string breachType;
        string respondent;
        bool activationConfirmed;
        uint256 timestamp;
    }

    PetitionSignal[] public signals;

    event ClauseActivated(string clauseID, string breachType, string respondent, bool activationConfirmed, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function activateClause(string memory clauseID, string memory breachType, string memory respondent, bool activationConfirmed) public {
        require(msg.sender == steward, "Only steward can activate");
        signals.push(PetitionSignal(clauseID, breachType, respondent, activationConfirmed, block.timestamp));
        emit ClauseActivated(clauseID, breachType, respondent, activationConfirmed, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, string memory, bool, uint256) {
        PetitionSignal memory s = signals[index];
        return (s.clauseID, s.breachType, s.respondent, s.activationConfirmed, s.timestamp);
    }
}
