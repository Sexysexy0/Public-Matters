pragma solidity ^0.8.20;

contract CoherenceCodex {
    address public overseer;
    uint256 public codexCount;

    struct CoherenceRule {
        uint256 id;
        string principle;   // Clarity, Alignment, Order
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => CoherenceRule) public rules;
    event CoherenceRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareCoherenceRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = CoherenceRule(codexCount, principle, description, block.timestamp);
        emit CoherenceRuleDeclared(codexCount, principle, description);
    }
}
