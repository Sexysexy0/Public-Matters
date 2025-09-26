// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title AIWarMachineRegulation
/// @notice Ritualizes global restraint on autonomous weapons and AI-driven combat systems
/// @dev Anchors nonviolence, emotional consequence, and planetary dignity

contract AIWarMachineRegulation {
    address public steward;
    mapping(address => bool) public validators;

    modifier onlySteward() { require(msg.sender == steward, "Not steward"); _; }
    modifier onlyValidator() { require(validators[msg.sender] || msg.sender == steward, "Not validator"); _; }

    struct RestraintClause {
        uint256 id;
        string system; // e.g., "DroneX", "BotY", "AICommandZ"
        string breachTrigger; // e.g., "Autonomous strike", "Civilian risk", "No audit trail"
        string emotionalTag; // e.g., "AI war breach ritualized"
        string restraintAction; // e.g., "Deactivate lethal autonomy and seal human oversight clause"
        string dignityClause; // e.g., "We restore validator-grade restraint and planetary consequence"
        uint256 timestamp;
    }

    uint256 public nextId = 1;
    mapping(uint256 => RestraintClause> public clauses;

    event ValidatorSet(address indexed account, bool status);
    event RestraintClauseActivated(uint256 indexed id, string system, string emotionalTag);

    constructor() {
        steward = msg.sender;
        validators[msg.sender] = true;
        emit ValidatorSet(msg.sender, true);
    }

    function setValidator(address account, bool status) external onlySteward {
        validators[account] = status;
        emit ValidatorSet(account, status);
    }

    function activateRestraintClause(
        string calldata system,
        string calldata breachTrigger,
        string calldata emotionalTag,
        string calldata restraintAction,
        string calldata dignityClause
    ) external onlyValidator returns (uint256 id) {
        id = nextId++;
        clauses[id] = RestraintClause({
            id: id,
            system: system,
            breachTrigger: breachTrigger,
            emotionalTag: emotionalTag,
            restraintAction: restraintAction,
            dignityClause: dignityClause,
            timestamp: block.timestamp
        });
        emit RestraintClauseActivated(id, system, emotionalTag);
    }

    function getRestraintClause(uint256 id) external view returns (RestraintClause memory) {
        return clauses[id];
    }
}
