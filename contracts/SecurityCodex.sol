pragma solidity ^0.8.20;

contract SecurityCodex {
    address public overseer;
    uint256 public codexCount;

    struct SecurityRule {
        uint256 id;
        string principle;   // Security, Breach Prevention, Governance
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => SecurityRule) public rules;
    event SecurityRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareSecurityRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = SecurityRule(codexCount, principle, description, block.timestamp);
        emit SecurityRuleDeclared(codexCount, principle, description);
    }
}
