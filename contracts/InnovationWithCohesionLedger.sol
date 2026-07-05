pragma solidity ^0.8.20;

contract InnovationWithCohesionLedger {
    address public overseer;
    uint256 public entryCount;

    struct CohesionRule {
        uint256 id;
        string principle;   // Innovation With Cohesion
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => CohesionRule) public entries;
    event CohesionRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareCohesionRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = CohesionRule(entryCount, principle, description, block.timestamp);
        emit CohesionRuleDeclared(entryCount, principle, description);
    }
}
