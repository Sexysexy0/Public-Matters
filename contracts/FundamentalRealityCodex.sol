pragma solidity ^0.8.20;

/// @title FundamentalRealityCodex
/// @notice Encodes covenant for redefining fundamental reality.
/// @dev Anchors reality, consciousness, and safeguard rules.

contract FundamentalRealityCodex {
    address public overseer;
    uint256 public codexCount;

    struct RealityRule {
        uint256 id;
        string principle;   // Reality, Consciousness, Safeguard
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => RealityRule> public rules;
    event RealityRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareRealityRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = RealityRule(codexCount, principle, description, block.timestamp);
        emit RealityRuleDeclared(codexCount, principle, description);
    }
}
