pragma solidity ^0.8.20;

contract FederationCodex {
    address public overseer;
    uint256 public codexCount;

    struct FederationRule {
        uint256 id;
        string principle;   // Federation, Shared Governance, Unity
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => FederationRule) public rules;
    event FederationRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareFederationRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = FederationRule(codexCount, principle, description, block.timestamp);
        emit FederationRuleDeclared(codexCount, principle, description);
    }
}
