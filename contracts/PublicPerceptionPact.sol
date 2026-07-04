pragma solidity ^0.8.20;

/// @title PublicPerceptionPact
/// @notice Encodes visibility and perception management rules.
/// @dev Anchors strategies for making ECE visible to society.

contract PublicPerceptionPact {
    address public overseer;
    uint256 public pactCount;

    struct PerceptionRule {
        uint256 id;
        string principle;   // Visibility, Outreach, Perception
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => PerceptionRule> public rules;
    event PerceptionRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declarePerceptionRule(string calldata principle, string calldata description) external onlyOverseer {
        pactCount++;
        rules[pactCount] = PerceptionRule(pactCount, principle, description, block.timestamp);
        emit PerceptionRuleDeclared(pactCount, principle, description);
    }
}
