// GlobalResonanceDAO.sol
pragma solidity ^0.8.0;

contract GlobalResonanceDAO {
    struct Initiative {
        uint256 id;
        string program;    // e.g. "Global Leadership Training Program"
        string resonance;  // e.g. "Align experiential learning with conceptual frameworks"
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
