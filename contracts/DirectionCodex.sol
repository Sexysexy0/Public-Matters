pragma solidity ^0.8.20;

contract DirectionCodex {
    address public overseer;
    uint256 public codexCount;

    struct DirectionRule {
        uint256 id;
        string principle;   // Path, Orientation, Clarity
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => DirectionRule) public rules;
    event DirectionRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareDirectionRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = DirectionRule(codexCount, principle, description, block.timestamp);
        emit DirectionRuleDeclared(codexCount, principle, description);
    }
}
