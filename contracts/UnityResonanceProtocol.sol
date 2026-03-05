// UnityResonanceProtocol.sol
pragma solidity ^0.8.0;

contract UnityResonanceProtocol {
    struct Initiative {
        uint256 id;
        string community; // e.g. "Regional Bloc"
        string effort;    // e.g. "Cultural exchange program"
        string outcome;   // e.g. "Strengthened ties"
        uint256 timestamp;
    }

    uint256 public initiativeCount;
    mapping(uint256 => Initiative) public initiatives;

    event InitiativeLogged(uint256 id, string community, string effort, string outcome);

    function logInitiative(string memory community, string memory effort, string memory outcome) public {
        initiativeCount++;
        initiatives[initiativeCount] = Initiative(initiativeCount, community, effort, outcome, block.timestamp);
        emit InitiativeLogged(initiativeCount, community, effort, outcome);
    }
}
