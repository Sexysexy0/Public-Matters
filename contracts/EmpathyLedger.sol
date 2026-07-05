pragma solidity ^0.8.20;

contract EmpathyLedger {
    address public overseer;
    uint256 public entryCount;

    struct EmpathyRule {
        uint256 id;
        string principle;   // Compassion, Shared Feeling, Care
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => EmpathyRule) public entries;
    event EmpathyRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareEmpathyRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = EmpathyRule(entryCount, principle, description, block.timestamp);
        emit EmpathyRuleDeclared(entryCount, principle, description);
    }
}
