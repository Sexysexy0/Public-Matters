pragma solidity ^0.8.20;

/// @title ScienceLimitsCharter
/// @notice Encodes covenant for scientific + theological boundary ethics.
/// @dev Anchors limits, assumptions, and safeguard rules.

contract ScienceLimitsCharter {
    address public overseer;
    uint256 public charterCount;

    struct LimitsRule {
        uint256 id;
        string principle;   // Limits, Assumptions, Safeguard
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => LimitsRule> public charters;
    event LimitsRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareLimitsRule(string calldata principle, string calldata description) external onlyOverseer {
        charterCount++;
        charters[charterCount] = LimitsRule(charterCount, principle, description, block.timestamp);
        emit LimitsRuleDeclared(charterCount, principle, description);
    }
}
