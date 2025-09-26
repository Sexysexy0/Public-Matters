// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title AIWeaponRestraintProtocol
/// @notice Ritualizes removal of AI and training tools from military weaponization
/// @dev Anchors ethical learning, nonviolence, and planetary restraint

contract AIWeaponRestraintProtocol {
    address public steward;
    mapping(address => bool) public validators;

    modifier onlySteward() { require(msg.sender == steward, "Not steward"); _; }
    modifier onlyValidator() { require(validators[msg.sender] || msg.sender == steward, "Not validator"); _; }

    struct RestraintClause {
        uint256 id;
        string toolName; // e.g., "DroneSimX", "CombatAI", "TacticalTrainer"
        string breachTrigger; // e.g., "Repurposed for military exercise", "Used in lethal simulation"
        string emotionalTag; // e.g., "Training tool breach ritualized"
        string restraintAction; // e.g., "Deactivate military access and seal ethical learning clause"
        string dignityClause; // e.g., "We restore validator-grade restraint and nonviolence sanctum"
        uint256 timestamp;
    }

    uint256 public nextId = 1;
    mapping(uint256 => RestraintClause> public clauses;

    event ValidatorSet(address indexed account, bool status);
    event RestraintClauseActivated(uint256 indexed id, string toolName, string emotionalTag);

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
        string calldata toolName,
        string calldata breachTrigger,
        string calldata emotionalTag,
        string calldata restraintAction,
        string calldata dignityClause
    ) external onlyValidator returns (uint256 id) {
        id = nextId++;
        clauses[id] = RestraintClause({
            id: id,
            toolName: toolName,
            breachTrigger: breachTrigger,
            emotionalTag: emotionalTag,
            restraintAction: restraintAction,
            dignityClause: dignityClause,
            timestamp: block.timestamp
        });
        emit RestraintClauseActivated(id, toolName, emotionalTag);
    }

    function getRestraintClause(uint256 id) external view returns (RestraintClause memory) {
        return clauses[id];
    }
}
