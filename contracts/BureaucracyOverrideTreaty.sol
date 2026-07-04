pragma solidity ^0.8.20;

/// @title BureaucracyOverrideTreaty
/// @notice Encodes human override rights in AI-run bureaucracies.
/// @dev Anchors override, appeal, and safeguard rules.

contract BureaucracyOverrideTreaty {
    address public overseer;
    uint256 public treatyCount;

    struct OverrideRule {
        uint256 id;
        string principle;   // Override, Appeal, Safeguard
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => OverrideRule> public treaties;
    event OverrideRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareOverrideRule(string calldata principle, string calldata description) external onlyOverseer {
        treatyCount++;
        treaties[treatyCount] = OverrideRule(treatyCount, principle, description, block.timestamp);
        emit OverrideRuleDeclared(treatyCount, principle, description);
    }
}
