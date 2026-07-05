pragma solidity ^0.8.20;

contract DynamicEquilibriumLedger {
    address public overseer;
    uint256 public entryCount;

    struct EquilibriumRule {
        uint256 id;
        string principle;   // Dynamic Equilibrium, Adaptive Balance
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => EquilibriumRule) public entries;
    event EquilibriumRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareEquilibriumRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = EquilibriumRule(entryCount, principle, description, block.timestamp);
        emit EquilibriumRuleDeclared(entryCount, principle, description);
    }
}
