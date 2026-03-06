// SharedResponsibilityProtocol.sol
pragma solidity ^0.8.0;

contract SharedResponsibilityProtocol {
    struct Initiative {
        uint256 id;
        string challenge;  // e.g. "Climate Change"
        string action;     // e.g. "Collective action on global challenges"
        uint256 timestamp;
    }

    uint256 public initiativeCount;
    mapping(uint256 => Initiative) public initiatives;

    event InitiativeLogged(uint256 id, string challenge, string action);

    function logInitiative(string memory challenge, string memory action) public {
        initiativeCount++;
        initiatives[initiativeCount] = Initiative(initiativeCount, challenge, action, block.timestamp);
        emit InitiativeLogged(initiativeCount, challenge, action);
    }
}
