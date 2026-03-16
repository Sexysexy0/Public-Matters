// InnovationResonanceDAO.sol
pragma solidity ^0.8.0;

contract InnovationResonanceDAO {
    struct Initiative {
        uint256 id;
        string program;    // e.g. "Creative Growth Program"
        string resonance;  // e.g. "Align governance with innovation and knowledge sharing"
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
