pragma solidity ^0.8.20;

/// @title SensemakingCharter
/// @notice Encodes iterative sensemaking processes for intelligence analysis.
/// @dev Anchors discovery, hypothesis generation, and verification.

contract SensemakingCharter {
    address public overseer;
    uint256 public charterCount;

    struct SensemakingRule {
        uint256 id;
        string principle;   // Discovery, Hypothesis, Verification
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => SensemakingRule> public rules;
    event SensemakingRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareSensemakingRule(string calldata principle, string calldata description) external onlyOverseer {
        charterCount++;
        rules[charterCount] = SensemakingRule(charterCount, principle, description, block.timestamp);
        emit SensemakingRuleDeclared(charterCount, principle, description);
    }
}
