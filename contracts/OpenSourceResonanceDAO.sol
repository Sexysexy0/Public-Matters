// OpenSourceResonanceDAO.sol
pragma solidity ^0.8.0;

contract OpenSourceResonanceDAO {
    struct Initiative {
        uint256 id;
        string program;    // e.g. "Community Maintainer Support Program"
        string resonance;  // e.g. "Align governance with open-source resilience"
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
