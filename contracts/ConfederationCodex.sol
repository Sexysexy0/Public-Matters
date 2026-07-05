pragma solidity ^0.8.20;

contract ConfederationCodex {
    address public overseer;
    uint256 public codexCount;

    struct ConfederationRule {
        uint256 id;
        string principle;   // Confederation, Shared Sovereignty, Cooperation
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => ConfederationRule) public rules;
    event ConfederationRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareConfederationRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = ConfederationRule(codexCount, principle, description, block.timestamp);
        emit ConfederationRuleDeclared(codexCount, principle, description);
    }
}
