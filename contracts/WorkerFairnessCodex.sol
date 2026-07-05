pragma solidity ^0.8.20;

/// @title WorkerFairnessCodex
/// @notice Covenant for worker protection against heat.
/// @dev Anchors safety, equity, and resilience.

contract WorkerFairnessCodex {
    address public overseer;
    uint256 public codexCount;

    struct FairnessRule {
        uint256 id;
        string principle;   // Worker Protection, Heat Safety, Equity
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => FairnessRule) public rules;
    event FairnessRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareFairnessRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = FairnessRule(codexCount, principle, description, block.timestamp);
        emit FairnessRuleDeclared(codexCount, principle, description);
    }
}
