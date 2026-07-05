pragma solidity ^0.8.20;

/// @title CollaborationOutreachPact
/// @notice Encodes outreach and NGO/CSO cooperation safeguards.
/// @dev Anchors stakeholder engagement and participation rules.

contract CollaborationOutreachPact {
    address public overseer;
    uint256 public pactCount;

    struct OutreachRule {
        uint256 id;
        string principle;   // Outreach, Cooperation, Participation
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => OutreachRule> public rules;
    event OutreachRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareOutreachRule(string calldata principle, string calldata description) external onlyOverseer {
        pactCount++;
        rules[pactCount] = OutreachRule(pactCount, principle, description, block.timestamp);
        emit OutreachRuleDeclared(pactCount, principle, description);
    }
}
