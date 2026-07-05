pragma solidity ^0.8.20;

contract SharedRiskLedger {
    address public overseer;
    uint256 public entryCount;

    struct RiskRule {
        uint256 id;
        string principle;   // Shared Risk, Collective Responsibility
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => RiskRule) public entries;
    event RiskRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareRiskRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = RiskRule(entryCount, principle, description, block.timestamp);
        emit RiskRuleDeclared(entryCount, principle, description);
    }
}
