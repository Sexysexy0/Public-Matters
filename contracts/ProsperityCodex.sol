pragma solidity ^0.8.20;

contract ProsperityCodex {
    address public overseer;
    uint256 public codexCount;

    struct ProsperityRule {
        uint256 id;
        string principle;   // Prosperity, Abundance, Shared Wealth
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => ProsperityRule) public rules;
    event ProsperityRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareProsperityRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = ProsperityRule(codexCount, principle, description, block.timestamp);
        emit ProsperityRuleDeclared(codexCount, principle, description);
    }
}
