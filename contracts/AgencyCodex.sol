pragma solidity ^0.8.20;

/// @title AgencyCodex
/// @notice Safeguards against unpredictable AI agency.
/// @dev Anchors monitoring, override, and containment rules.

contract AgencyCodex {
    address public overseer;
    uint256 public ruleCount;

    struct AgencyRule {
        uint256 id;
        string principle;   // Monitoring, Override, Containment
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => AgencyRule> public rules;
    event AgencyRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareAgencyRule(string calldata principle, string calldata description) external onlyOverseer {
        ruleCount++;
        rules[ruleCount] = AgencyRule(ruleCount, principle, description, block.timestamp);
        emit AgencyRuleDeclared(ruleCount, principle, description);
    }
}
