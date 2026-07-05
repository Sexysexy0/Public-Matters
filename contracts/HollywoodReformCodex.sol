pragma solidity ^0.8.20;

contract HollywoodReformCodex {
    address public overseer;
    uint256 public codexCount;

    struct ReformRule {
        uint256 id;
        string principle;   // Authenticity, Accountability, Audience Trust
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => ReformRule) public rules;
    event ReformRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareReformRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = ReformRule(codexCount, principle, description, block.timestamp);
        emit ReformRuleDeclared(codexCount, principle, description);
    }
}
