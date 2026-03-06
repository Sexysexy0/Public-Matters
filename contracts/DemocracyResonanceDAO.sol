// DemocracyResonanceDAO.sol
pragma solidity ^0.8.0;

contract DemocracyResonanceDAO {
    struct Initiative {
        uint256 id;
        string reform;     // e.g. "Anti-Political Dynasty Bill"
        string resonance;  // e.g. "Empower fair representation and limit dynasties"
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
