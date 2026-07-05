pragma solidity ^0.8.20;

contract FearCodex {
    address public overseer;
    uint256 public codexCount;

    struct FearRule {
        uint256 id;
        string principle;   // Fear, Dread, Humility
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => FearRule) public rules;
    event FearRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareFearRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = FearRule(codexCount, principle, description, block.timestamp);
        emit FearRuleDeclared(codexCount, principle, description);
    }
}
