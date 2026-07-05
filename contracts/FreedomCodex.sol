pragma solidity ^0.8.20;

contract FreedomCodex {
    address public overseer;
    uint256 public codexCount;

    struct FreedomRule {
        uint256 id;
        string principle;   // Freedom, Liberty, Dignity
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => FreedomRule) public rules;
    event FreedomRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareFreedomRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = FreedomRule(codexCount, principle, description, block.timestamp);
        emit FreedomRuleDeclared(codexCount, principle, description);
    }
}
