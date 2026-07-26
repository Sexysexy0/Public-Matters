// InclusiveGrowthResonanceProtocol.sol
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract InclusiveGrowthResonanceProtocol is Ownable {

    constructor() Ownable(msg.sender) {}

    struct Initiative {
        uint256 id;
        string program;    // e.g. "Microfinance for Rural Communities"
        string outcome;    // e.g. "Empower marginalized groups"
        uint256 timestamp;
    }

    uint256 public initiativeCount;
    mapping(uint256 => Initiative) public initiatives;

    event InitiativeLogged(uint256 id, string program, string outcome);

    function logInitiative(string memory program, string memory outcome) public {
        initiativeCount++;
        initiatives[initiativeCount] = Initiative(initiativeCount, program, outcome, block.timestamp);
        emit InitiativeLogged(initiativeCount, program, outcome);
    }
}
