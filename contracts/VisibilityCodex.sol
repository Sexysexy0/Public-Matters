pragma solidity ^0.8.20;

contract VisibilityCodex {
    address public overseer;
    uint256 public codexCount;

    struct VisibilityRule {
        uint256 id;
        string principle;   // Visibility, Recognition, Provenance
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => VisibilityRule) public rules;
    event VisibilityRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareVisibilityRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = VisibilityRule(codexCount, principle, description, block.timestamp);
        emit VisibilityRuleDeclared(codexCount, principle, description);
    }
}
