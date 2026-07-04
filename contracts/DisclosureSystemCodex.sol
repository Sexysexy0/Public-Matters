pragma solidity ^0.8.20;

/// @title DisclosureSystemCodex
/// @notice Encodes governance for digital disclosure systems.
/// @dev Anchors workflows, automation, and compliance safeguards.

contract DisclosureSystemCodex {
    address public overseer;
    uint256 public systemCount;

    struct SystemRule {
        uint256 id;
        string principle;   // Workflow, Automation, Compliance
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => SystemRule> public rules;
    event SystemRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareSystemRule(string calldata principle, string calldata description) external onlyOverseer {
        systemCount++;
        rules[systemCount] = SystemRule(systemCount, principle, description, block.timestamp);
        emit SystemRuleDeclared(systemCount, principle, description);
    }
}
