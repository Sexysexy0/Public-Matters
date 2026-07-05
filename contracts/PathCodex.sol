pragma solidity ^0.8.20;

contract PathCodex {
    address public overseer;
    uint256 public codexCount;

    struct PathRule {
        uint256 id;
        string principle;   // Journey, Progress, Navigation
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => PathRule) public rules;
    event PathRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declarePathRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = PathRule(codexCount, principle, description, block.timestamp);
        emit PathRuleDeclared(codexCount, principle, description);
    }
}
