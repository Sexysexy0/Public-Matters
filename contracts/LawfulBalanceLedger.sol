pragma solidity ^0.8.20;

contract LawfulBalanceLedger {
    address public overseer;
    uint256 public entryCount;

    struct BalanceRule {
        uint256 id;
        string principle;   // Lawful Balance, Checks
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => BalanceRule) public entries;
    event BalanceRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareBalanceRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = BalanceRule(entryCount, principle, description, block.timestamp);
        emit BalanceRuleDeclared(entryCount, principle, description);
    }
}
