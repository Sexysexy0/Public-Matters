pragma solidity ^0.8.20;

contract HarmonizedGovernanceLedger {
    address public overseer;
    uint256 public entryCount;

    struct GovernanceRule {
        uint256 id;
        string principle;   // Harmonized Governance, Fair Leadership
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => GovernanceRule) public entries;
    event GovernanceRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareGovernanceRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = GovernanceRule(entryCount, principle, description, block.timestamp);
        emit GovernanceRuleDeclared(entryCount, principle, description);
    }
}
