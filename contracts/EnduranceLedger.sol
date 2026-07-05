pragma solidity ^0.8.20;

contract EnduranceLedger {
    address public overseer;
    uint256 public entryCount;

    struct EnduranceRule {
        uint256 id;
        string principle;   // Endurance, Resilience, Survival
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => EnduranceRule) public entries;
    event EnduranceRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareEnduranceRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = EnduranceRule(entryCount, principle, description, block.timestamp);
        emit EnduranceRuleDeclared(entryCount, principle, description);
    }
}
