pragma solidity ^0.8.20;

contract FlourishingCodex {
    address public overseer;
    uint256 public codexCount;

    struct FlourishingRule {
        uint256 id;
        string principle;   // Flourishing, Thriving Communities, Prosperity
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => FlourishingRule) public rules;
    event FlourishingRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareFlourishingRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = FlourishingRule(codexCount, principle, description, block.timestamp);
        emit FlourishingRuleDeclared(codexCount, principle, description);
    }
}
