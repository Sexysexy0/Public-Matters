pragma solidity ^0.8.20;

contract RightEffortCodex {
    address public overseer;
    uint256 public codexCount;

    struct EffortRule {
        uint256 id;
        string principle;   // Right Effort, Wholesome States
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => EffortRule) public rules;
    event EffortRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareEffortRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = EffortRule(codexCount, principle, description, block.timestamp);
        emit EffortRuleDeclared(codexCount, principle, description);
    }
}
