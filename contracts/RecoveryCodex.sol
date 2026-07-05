pragma solidity ^0.8.20;

contract RecoveryCodex {
    address public overseer;
    uint256 public codexCount;

    struct RecoveryRule {
        uint256 id;
        string principle;   // Recovery, Balance, Momentum
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => RecoveryRule) public rules;
    event RecoveryRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareRecoveryRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = RecoveryRule(codexCount, principle, description, block.timestamp);
        emit RecoveryRuleDeclared(codexCount, principle, description);
    }
}
