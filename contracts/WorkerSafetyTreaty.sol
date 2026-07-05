pragma solidity ^0.8.20;

/// @title WorkerSafetyTreaty
/// @notice Covenant for occupational safeguards against heat.
/// @dev Anchors safety, dignity, and fairness.

contract WorkerSafetyTreaty {
    address public overseer;
    uint256 public treatyCount;

    struct SafetyRule {
        uint256 id;
        string principle;   // Worker Safety, Heat Protection, Equity
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => SafetyRule) public treaties;
    event SafetyRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareSafetyRule(string calldata principle, string calldata description) external onlyOverseer {
        treatyCount++;
        treaties[treatyCount] = SafetyRule(treatyCount, principle, description, block.timestamp);
        emit SafetyRuleDeclared(treatyCount, principle, description);
    }
}
