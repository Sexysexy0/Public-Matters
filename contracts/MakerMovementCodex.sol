pragma solidity ^0.8.20;

/// @title MakerMovementCodex
/// @notice Encodes maker movement principles for visibility and engagement.
/// @dev Anchors tinkering, hands-on learning, and project-based exploration.

contract MakerMovementCodex {
    address public overseer;
    uint256 public makerCount;

    struct MakerRule {
        uint256 id;
        string principle;   // Tinkering, Hands-on, Visibility
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => MakerRule> public rules;
    event MakerRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareMakerRule(string calldata principle, string calldata description) external onlyOverseer {
        makerCount++;
        rules[makerCount] = MakerRule(makerCount, principle, description, block.timestamp);
        emit MakerRuleDeclared(makerCount, principle, description);
    }
}
