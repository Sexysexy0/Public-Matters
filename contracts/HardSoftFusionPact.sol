pragma solidity ^0.8.20;

/// @title HardSoftFusionPact
/// @notice Encodes fusion rules for hard (sensor) and soft (textual/social) data.
/// @dev Anchors multi-INT integration and uncertainty handling.

contract HardSoftFusionPact {
    address public overseer;
    uint256 public fusionCount;

    struct FusionRule {
        uint256 id;
        string principle;   // Hard data, Soft data, Fusion
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => FusionRule> public fusions;
    event FusionRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareFusionRule(string calldata principle, string calldata description) external onlyOverseer {
        fusionCount++;
        fusions[fusionCount] = FusionRule(fusionCount, principle, description, block.timestamp);
        emit FusionRuleDeclared(fusionCount, principle, description);
    }
}
