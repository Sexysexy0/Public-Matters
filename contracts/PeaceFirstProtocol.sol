// PeaceFirstProtocol.sol
pragma solidity ^0.8.0;

contract PeaceFirstProtocol {
    struct Initiative {
        uint256 id;
        string approach;   // e.g. "Diplomatic Negotiation"
        string safeguard;  // e.g. "Bias AI toward diplomacy and de-escalation"
        uint256 timestamp;
    }

    uint256 public initiativeCount;
    mapping(uint256 => Initiative) public initiatives;

    event InitiativeLogged(uint256 id, string approach, string safeguard);

    function logInitiative(string memory approach, string memory safeguard) public {
        initiativeCount++;
        initiatives[initiativeCount] = Initiative(initiativeCount, approach, safeguard, block.timestamp);
        emit InitiativeLogged(initiativeCount, approach, safeguard);
    }
}
