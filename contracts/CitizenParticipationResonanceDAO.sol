// CitizenParticipationResonanceDAO.sol
pragma solidity ^0.8.0;

contract CitizenParticipationResonanceDAO {
    struct Initiative {
        uint256 id;
        string program;   // e.g. "Participatory Budgeting"
        string outcome;   // e.g. "Expand direct involvement in decision-making"
        bool active;
    }

    uint256 public initiativeCount;
    mapping(uint256 => Initiative) public initiatives;

    event InitiativeActivated(uint256 id, string program, string outcome);

    function activateInitiative(string memory program, string memory outcome) public {
        initiativeCount++;
        initiatives[initiativeCount] = Initiative(initiativeCount, program, outcome, true);
        emit InitiativeActivated(initiativeCount, program, outcome);
    }
}
