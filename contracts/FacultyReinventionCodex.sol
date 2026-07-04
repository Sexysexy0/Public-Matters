pragma solidity ^0.8.20;

/// @title FacultyReinventionCodex
/// @notice Encodes faculty reinvention cycles.
/// @dev Anchors adaptive career shifts and new research directions.

contract FacultyReinventionCodex {
    address public overseer;
    uint256 public reinventionCount;

    struct Reinvention {
        uint256 id;
        string principle;   // Career, Adaptation, Renewal
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => Reinvention> public reinventions;
    event ReinventionDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareReinvention(string calldata principle, string calldata description) external onlyOverseer {
        reinventionCount++;
        reinventions[reinventionCount] = Reinvention(reinventionCount, principle, description, block.timestamp);
        emit ReinventionDeclared(reinventionCount, principle, description);
    }
}
