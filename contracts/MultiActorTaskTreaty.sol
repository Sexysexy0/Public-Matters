pragma solidity ^0.8.20;

/// @title MultiActorTaskTreaty
/// @notice Encodes rules for coordinated multi-actor tasks.
/// @dev Anchors group behaviors, collective actions, and joint missions.

contract MultiActorTaskTreaty {
    address public overseer;
    uint256 public taskCount;

    struct TaskRule {
        uint256 id;
        string principle;   // Coordination, Group, Collective
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => TaskRule> public tasks;
    event TaskRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareTaskRule(string calldata principle, string calldata description) external onlyOverseer {
        taskCount++;
        tasks[taskCount] = TaskRule(taskCount, principle, description, block.timestamp);
        emit TaskRuleDeclared(taskCount, principle, description);
    }
}
