pragma solidity ^0.8.20;

/// @title PersonalDisciplineTreaty
/// @notice Covenant for discipline safeguards.
/// @dev Anchors habits, consistency, and self-respect.

contract PersonalDisciplineTreaty {
    address public overseer;
    uint256 public treatyCount;

    struct DisciplineRule {
        uint256 id;
        string principle;   // Personal Discipline, Habits, Consistency
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => DisciplineRule) public treaties;
    event DisciplineRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareDisciplineRule(string calldata principle, string calldata description) external onlyOverseer {
        treatyCount++;
        treaties[treatyCount] = DisciplineRule(treatyCount, principle, description, block.timestamp);
        emit DisciplineRuleDeclared(treatyCount, principle, description);
    }
}
