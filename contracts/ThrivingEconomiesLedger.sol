pragma solidity ^0.8.20;

contract ThrivingEconomiesLedger {
    address public overseer;
    uint256 public entryCount;

    struct EconomyRule {
        uint256 id;
        string principle;   // Thriving Economies, Resilience
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => EconomyRule) public entries;
    event EconomyRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareEconomyRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = EconomyRule(entryCount, principle, description, block.timestamp);
        emit EconomyRuleDeclared(entryCount, principle, description);
    }
}
