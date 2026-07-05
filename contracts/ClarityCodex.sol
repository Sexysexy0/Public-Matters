pragma solidity ^0.8.20;

contract ClarityCodex {
    address public overseer;
    uint256 public codexCount;

    struct ClarityRule {
        uint256 id;
        string principle;   // Clarity, Transparency, Truth
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => ClarityRule) public rules;
    event ClarityRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareClarityRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = ClarityRule(codexCount, principle, description, block.timestamp);
        emit ClarityRuleDeclared(codexCount, principle, description);
    }
}
