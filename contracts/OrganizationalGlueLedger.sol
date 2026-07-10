pragma solidity ^0.8.20;

contract OrganizationalGlueLedger {
    address public overseer;
    uint256 public entryCount;

    struct GlueRule {
        uint256 id;
        string principle;   // Organizational Glue, Trust, Alignment
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => GlueRule) public entries;
    event GlueRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareGlueRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = GlueRule(entryCount, principle, description, block.timestamp);
        emit GlueRuleDeclared(entryCount, principle, description);
    }
}
