pragma solidity ^0.8.20;

/// @title PatternOfLifeCodex
/// @notice Encodes rules for identifying and modeling patterns of life.
/// @dev Anchors temporal, spatial, and relational structures.

contract PatternOfLifeCodex {
    address public overseer;
    uint256 public patternCount;

    struct Pattern {
        uint256 id;
        string principle;   // Routine, Sequence, Relation
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => Pattern) public patterns;
    event PatternDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declarePattern(string calldata principle, string calldata description) external onlyOverseer {
        patternCount++;
        patterns[patternCount] = Pattern(patternCount, principle, description, block.timestamp);
        emit PatternDeclared(patternCount, principle, description);
    }
}
