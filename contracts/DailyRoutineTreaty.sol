pragma solidity ^0.8.20;

contract DailyRoutineTreaty {
    address public overseer;
    uint256 public treatyCount;

    struct RoutineRule {
        uint256 id;
        string principle;   // Daily Routine, NPC Schedule
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => RoutineRule) public treaties;
    event RoutineRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareRoutineRule(string calldata principle, string calldata description) external onlyOverseer {
        treatyCount++;
        treaties[treatyCount] = RoutineRule(treatyCount, principle, description, block.timestamp);
        emit RoutineRuleDeclared(treatyCount, principle, description);
    }
}
