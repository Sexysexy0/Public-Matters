pragma solidity ^0.8.20;

contract BalanceCodex {
    address public overseer;
    uint256 public codexCount;

    struct BalanceRule {
        uint256 id;
        string principle;   // Balance, Fairness, Stability
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => BalanceRule) public rules;
    event BalanceRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareBalanceRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = BalanceRule(codexCount, principle, description, block.timestamp);
        emit BalanceRuleDeclared(codexCount, principle, description);
    }
}
