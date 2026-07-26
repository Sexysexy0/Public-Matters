// ParticipationResonanceDAO.sol
pragma solidity ^0.8.0;

contract ParticipationResonanceDAO {
    struct Initiative {
        uint256 id;
        string program;    // e.g. "Citizen Watchdog Program"
        string resonance;  // e.g. "Align democracy with active citizen role"
        bool active;
    }

    uint256 public initiativeCount;
    mapping(uint256 => Initiative) public initiatives;

    event InitiativeActivated(uint256 id, string program, string resonance);

    function activateInitiative(string memory program, string memory resonance) public {
        initiativeCount++;
        initiatives[initiativeCount] = Initiative(initiativeCount, program, resonance, true);
        emit InitiativeActivated(initiativeCount, program, resonance);
    }
}
