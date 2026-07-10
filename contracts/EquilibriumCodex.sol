pragma solidity ^0.8.20;

contract EquilibriumCodex {
    address public overseer;
    uint256 public codexCount;

    struct EquilibriumRule {
        uint256 id;
        string principle;   // Equilibrium, Stability, Governance
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => EquilibriumRule) public rules;
    event EquilibriumRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareEquilibriumRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = EquilibriumRule(codexCount, principle, description, block.timestamp);
        emit EquilibriumRuleDeclared(codexCount, principle, description);
    }
}
