pragma solidity ^0.8.20;

/// @title CollectiveWisdomCodex
/// @notice Encodes covenant for collective wisdom safeguards.
/// @dev Anchors shared knowledge, community resilience, and truth validation.

contract CollectiveWisdomCodex {
    address public overseer;
    uint256 public codexCount;

    struct WisdomRule {
        uint256 id;
        string principle;   // Knowledge, Resilience, Validation
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => WisdomRule> public rules;
    event WisdomRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareWisdomRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = WisdomRule(codexCount, principle, description, block.timestamp);
        emit WisdomRuleDeclared(codexCount, principle, description);
    }
}
