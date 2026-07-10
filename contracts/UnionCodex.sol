pragma solidity ^0.8.20;

contract UnionCodex {
    address public overseer;
    uint256 public codexCount;

    struct UnionRule {
        uint256 id;
        string principle;   // Union, Collective Identity, Solidarity
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => UnionRule) public rules;
    event UnionRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareUnionRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = UnionRule(codexCount, principle, description, block.timestamp);
        emit UnionRuleDeclared(codexCount, principle, description);
    }
}
