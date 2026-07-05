pragma solidity ^0.8.20;

contract ClarityLedger {
    address public overseer;
    uint256 public entryCount;

    struct ClarityRule {
        uint256 id;
        string principle;   // Transparency, Precision, Lucidity
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => ClarityRule) public entries;
    event ClarityRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareClarityRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = ClarityRule(entryCount, principle, description, block.timestamp);
        emit ClarityRuleDeclared(entryCount, principle, description);
    }
}
