// PartySystemResonanceDAO.sol
pragma solidity ^0.8.0;

contract PartySystemResonanceDAO {
    struct Initiative {
        uint256 id;
        string reform;     // e.g. "Closed Party System"
        string resonance;  // e.g. "Strengthen ideological accountability"
        bool active;
    }

    uint256 public initiativeCount;
    mapping(uint256 => Initiative) public initiatives;

    event InitiativeActivated(uint256 id, string reform, string resonance);

    function activateInitiative(string memory reform, string memory resonance) public {
        initiativeCount++;
        initiatives[initiativeCount] = Initiative(initiativeCount, reform, resonance, true);
        emit InitiativeActivated(initiativeCount, reform, resonance);
    }
}
