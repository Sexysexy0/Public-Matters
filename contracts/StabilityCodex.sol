pragma solidity ^0.8.20;

contract StabilityCodex {
    address public overseer;
    uint256 public codexCount;

    struct StabilityRule {
        uint256 id;
        string principle;   // Stability, Enduring Order, Durability
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => StabilityRule) public rules;
    event StabilityRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareStabilityRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = StabilityRule(codexCount, principle, description, block.timestamp);
        emit StabilityRuleDeclared(codexCount, principle, description);
    }
}
