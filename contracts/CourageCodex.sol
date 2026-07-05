pragma solidity ^0.8.20;

contract CourageCodex {
    address public overseer;
    uint256 public codexCount;

    struct CourageRule {
        uint256 id;
        string principle;   // Bravery, Resilience, Risk-Taking
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => CourageRule) public rules;
    event CourageRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareCourageRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = CourageRule(codexCount, principle, description, block.timestamp);
        emit CourageRuleDeclared(codexCount, principle, description);
    }
}
