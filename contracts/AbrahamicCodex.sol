pragma solidity ^0.8.20;

contract AbrahamicCodex {
    address public overseer;
    uint256 public codexCount;

    struct AbrahamicRule {
        uint256 id;
        string principle;   // Adventure, Sacrifice, Destiny, Leadership
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => AbrahamicRule) public rules;
    event AbrahamicRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareAbrahamicRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = AbrahamicRule(codexCount, principle, description, block.timestamp);
        emit AbrahamicRuleDeclared(codexCount, principle, description);
    }
}
