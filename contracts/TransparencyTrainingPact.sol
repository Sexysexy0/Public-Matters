pragma solidity ^0.8.20;

/// @title TransparencyTrainingPact
/// @notice Encodes staff training and awareness safeguards.
/// @dev Anchors briefings, e-learning, and handbook updates.

contract TransparencyTrainingPact {
    address public overseer;
    uint256 public pactCount;

    struct TrainingRule {
        uint256 id;
        string principle;   // Training, Awareness, Guidance
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => TrainingRule> public rules;
    event TrainingRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareTrainingRule(string calldata principle, string calldata description) external onlyOverseer {
        pactCount++;
        rules[pactCount] = TrainingRule(pactCount, principle, description, block.timestamp);
        emit TrainingRuleDeclared(pactCount, principle, description);
    }
}
