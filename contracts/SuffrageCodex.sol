pragma solidity ^0.8.20;

contract SuffrageCodex {
    address public overseer;
    uint256 public codexCount;

    struct SuffrageRule {
        uint256 id;
        string principle;   // Suffrage, Universality, Secrecy, Sovereignty
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => SuffrageRule) public rules;
    event SuffrageRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareSuffrageRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = SuffrageRule(codexCount, principle, description, block.timestamp);
        emit SuffrageRuleDeclared(codexCount, principle, description);
    }
}
