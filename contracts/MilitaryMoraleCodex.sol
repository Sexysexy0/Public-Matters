pragma solidity ^0.8.20;

/// @title MilitaryMoraleCodex
/// @notice Covenant for morale safeguards in military systems.
/// @dev Anchors justice fairness, dignity equity, systemic trust.

contract MilitaryMoraleCodex {
    address public overseer;
    uint256 public codexCount;

    struct MoraleRule {
        uint256 id;
        string principle;   // Military Morale, Justice, Trust
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => MoraleRule) public rules;
    event MoraleRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareMoraleRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = MoraleRule(codexCount, principle, description, block.timestamp);
        emit MoraleRuleDeclared(codexCount, principle, description);
    }
}
