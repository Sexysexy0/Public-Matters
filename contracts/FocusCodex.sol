pragma solidity ^0.8.20;

contract FocusCodex {
    address public overseer;
    uint256 public codexCount;

    struct FocusRule {
        uint256 id;
        string principle;   // Concentration, Clarity, Directed Effort
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => FocusRule) public rules;
    event FocusRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareFocusRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = FocusRule(codexCount, principle, description, block.timestamp);
        emit FocusRuleDeclared(codexCount, principle, description);
    }
}
