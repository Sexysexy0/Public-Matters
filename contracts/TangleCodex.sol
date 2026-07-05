pragma solidity ^0.8.20;

contract TangleCodex {
    address public overseer;
    uint256 public codexCount;

    struct TangleRule {
        uint256 id;
        string principle;   // Tangle, Dependent Origination
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => TangleRule) public rules;
    event TangleRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareTangleRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = TangleRule(codexCount, principle, description, block.timestamp);
        emit TangleRuleDeclared(codexCount, principle, description);
    }
}
