pragma solidity ^0.8.20;

contract OrderLedger {
    address public overseer;
    uint256 public entryCount;

    struct OrderRule {
        uint256 id;
        string principle;   // Structure, Discipline, Governance Clarity
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => OrderRule) public entries;
    event OrderRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareOrderRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = OrderRule(entryCount, principle, description, block.timestamp);
        emit OrderRuleDeclared(entryCount, principle, description);
    }
}
