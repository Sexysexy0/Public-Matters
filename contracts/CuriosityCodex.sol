pragma solidity ^0.8.20;

contract CuriosityCodex {
    address public overseer;
    uint256 public codexCount;

    struct CuriosityRule {
        uint256 id;
        string principle;   // Inquiry, Wonder, Knowledge
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => CuriosityRule) public rules;
    event CuriosityRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareCuriosityRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = CuriosityRule(codexCount, principle, description, block.timestamp);
        emit CuriosityRuleDeclared(codexCount, principle, description);
    }
}
