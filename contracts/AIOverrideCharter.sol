pragma solidity ^0.8.20;

/// @title AIOverrideCharter
/// @notice Encodes covenant for systemic human override rights.
/// @dev Anchors systemic appeal, override, and accountability safeguards.

contract AIOverrideCharter {
    address public overseer;
    uint256 public charterCount;

    struct OverrideRule {
        uint256 id;
        string principle;   // Appeal, Override, Accountability
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => OverrideRule> public charters;
    event OverrideRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareOverrideRule(string calldata principle, string calldata description) external onlyOverseer {
        charterCount++;
        charters[charterCount] = OverrideRule(charterCount, principle, description, block.timestamp);
        emit OverrideRuleDeclared(charterCount, principle, description);
    }
}
