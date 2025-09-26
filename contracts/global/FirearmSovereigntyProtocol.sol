// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title FirearmSovereigntyProtocol
/// @notice Ritualizes liberated firearm ownership with validator-grade accountability and emotional consequence mapping
/// @dev Anchors personal rights, communal safety, and breach immunity

contract FirearmSovereigntyProtocol {
    address public steward;
    mapping(address => bool) public validators;

    modifier onlySteward() { require(msg.sender == steward, "Not steward"); _; }
    modifier onlyValidator() { require(validators[msg.sender] || msg.sender == steward, "Not validator"); _; }

    struct SovereigntyClause {
        uint256 id;
        string region; // e.g., "Alberta", "Saskatchewan", "Philippines"
        string ownershipType; // e.g., "Personal defense", "Cultural heritage", "Sport shooting"
        string emotionalTag; // e.g., "Liberated but accountable"
        string accountabilityClause; // e.g., "Owner must pass safety audit and emotional consequence mapping"
        string restorationClause; // e.g., "We honor rights, seal responsibility, and protect communal dignity"
        uint256 timestamp;
    }

    uint256 public nextId = 1;
    mapping(uint256 => SovereigntyClause> public clauses;

    event ValidatorSet(address indexed account, bool status);
    event SovereigntyClauseActivated(uint256 indexed id, string region, string emotionalTag);

    constructor() {
        steward = msg.sender;
        validators[msg.sender] = true;
        emit ValidatorSet(msg.sender, true);
    }

    function setValidator(address account, bool status) external onlySteward {
        validators[account] = status;
        emit ValidatorSet(account, status);
    }

    function activateSovereigntyClause(
        string calldata region,
        string calldata ownershipType,
        string calldata emotionalTag,
        string calldata accountabilityClause,
        string calldata restorationClause
    ) external onlyValidator returns (uint256 id) {
        id = nextId++;
        clauses[id] = SovereigntyClause({
            id: id,
            region: region,
            ownershipType: ownershipType,
            emotionalTag: emotionalTag,
            accountabilityClause: accountabilityClause,
            restorationClause: restorationClause,
            timestamp: block.timestamp
        });
        emit SovereigntyClauseActivated(id, region, emotionalTag);
    }

    function getSovereigntyClause(uint256 id) external view returns (SovereigntyClause memory) {
        return clauses[id];
    }
}
