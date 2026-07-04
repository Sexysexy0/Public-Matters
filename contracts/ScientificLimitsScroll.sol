pragma solidity ^0.8.20;

/// @title ScientificLimitsScroll
/// @notice Encodes covenant for limits of scientific exploration.
/// @dev Anchors limits, ethics, and safeguard rules.

contract ScientificLimitsScroll {
    address public overseer;
    uint256 public scrollCount;

    struct LimitRule {
        uint256 id;
        string principle;   // Limits, Ethics, Safeguard
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => LimitRule> public rules;
    event LimitRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareLimitRule(string calldata principle, string calldata description) external onlyOverseer {
        scrollCount++;
        rules[scrollCount] = LimitRule(scrollCount, principle, description, block.timestamp);
        emit LimitRuleDeclared(scrollCount, principle, description);
    }
}
