// UnionResonanceDAO.sol
pragma solidity ^0.8.0;

contract UnionResonanceDAO {
    struct Initiative {
        uint256 id;
        string program;    // e.g. "Collective Bargaining Agreement"
        string resonance;  // e.g. "Strengthen collective bargaining power"
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
