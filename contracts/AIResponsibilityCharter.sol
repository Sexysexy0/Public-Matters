pragma solidity ^0.8.20;

/// @title AIResponsibilityCharter
/// @notice Encodes covenant for systemic responsibility in AI.
/// @dev Anchors responsibility, accountability, and safeguard rules.

contract AIResponsibilityCharter {
    address public overseer;
    uint256 public charterCount;

    struct ResponsibilityRule {
        uint256 id;
        string principle;   // Responsibility, Accountability, Safeguard
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => ResponsibilityRule> public charters;
    event ResponsibilityRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareResponsibilityRule(string calldata principle, string calldata description) external onlyOverseer {
        charterCount++;
        charters[charterCount] = ResponsibilityRule(charterCount, principle, description, block.timestamp);
        emit ResponsibilityRuleDeclared(charterCount, principle, description);
    }
}
