pragma solidity ^0.8.20;

/// @title StyleGovernancePact
/// @notice Encodes style governance rules.
/// @dev Anchors formatting, readability, and clarity safeguards.

contract StyleGovernancePact {
    address public overseer;
    uint256 public pactCount;

    struct StyleRule {
        uint256 id;
        string principle;   // Formatting, Readability, Clarity
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => StyleRule> public rules;
    event StyleRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareStyleRule(string calldata principle, string calldata description) external onlyOverseer {
        pactCount++;
        rules[pactCount] = StyleRule(pactCount, principle, description, block.timestamp);
        emit StyleRuleDeclared(pactCount, principle, description);
    }
}
