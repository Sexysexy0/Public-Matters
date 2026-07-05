pragma solidity ^0.8.20;

/// @title PerceptionInterfaceCodex
/// @notice Encodes covenant for perceptual interface safeguards.
/// @dev Anchors survival interface theory, perceptual limits, and anti-manipulation rules.

contract PerceptionInterfaceCodex {
    address public overseer;
    uint256 public codexCount;

    struct InterfaceRule {
        uint256 id;
        string principle;   // Survival Interface, Perceptual Limit, Safeguard
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => InterfaceRule> public rules;
    event InterfaceRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    /// @notice Declare a new perceptual safeguard rule
    /// @param principle Core perceptual principle (e.g., "Survival Interface")
    /// @param description Explanation of safeguard
    function declareInterfaceRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = InterfaceRule(codexCount, principle, description, block.timestamp);
        emit InterfaceRuleDeclared(codexCount, principle, description);
    }
}
