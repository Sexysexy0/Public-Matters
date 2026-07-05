pragma solidity ^0.8.20;

contract IntegrityCodex {
    address public overseer;
    uint256 public codexCount;

    struct IntegrityRule {
        uint256 id;
        string principle;   // Honesty, Truth, Trustworthiness
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => IntegrityRule) public rules;
    event IntegrityRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareIntegrityRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = IntegrityRule(codexCount, principle, description, block.timestamp);
        emit IntegrityRuleDeclared(codexCount, principle, description);
    }
}
