// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title BitcoinMoralHazardImmunityProtocol
/// @notice Ritualizes immunity against insider manipulation, activist governance, and economic distortion
/// @dev Anchors validator-grade consequence mapping and governance restraint

contract BitcoinMoralHazardImmunityProtocol {
    address public steward;
    mapping(address => bool) public validators;

    modifier onlySteward() { require(msg.sender == steward); _; }
    modifier onlyValidator() { require(validators[msg.sender] || msg.sender == steward); _; }

    struct HazardClause {
        uint256 id;
        string actorType; // e.g., "Core dev", "Exchange", "Protocol activist"
        string breachSummary; // e.g., "Pushed OP_RETURN expansion for insider gain"
        string emotionalTag; // e.g., "Moral hazard ritualized"
        string immunityAction; // e.g., "Seal governance restraint, block activist forks"
        string restorationClause; // e.g., "We restore validator-grade integrity and economic neutrality"
        uint256 timestamp;
    }

    uint256 public nextId = 1;
    mapping(uint256 => HazardClause> public clauses;

    event ValidatorSet(address indexed account, bool status);
    event HazardClauseActivated(uint256 indexed id, string actorType, string emotionalTag);

    constructor() {
        steward = msg.sender;
        validators[msg.sender] = true;
        emit ValidatorSet(msg.sender, true);
    }

    function setValidator(address account, bool status) external onlySteward {
        validators[account] = status;
        emit ValidatorSet(account, status);
    }

    function activateHazardClause(
        string calldata actorType,
        string calldata breachSummary,
        string calldata emotionalTag,
        string calldata immunityAction,
        string calldata restorationClause
    ) external onlyValidator returns (uint256 id) {
        id = nextId++;
        clauses[id] = HazardClause({
            id: id,
            actorType: actorType,
            breachSummary: breachSummary,
            emotionalTag: emotionalTag,
            immunityAction: immunityAction,
            restorationClause: restorationClause,
            timestamp: block.timestamp
        });
        emit HazardClauseActivated(id, actorType, emotionalTag);
    }

    function getHazardClause(uint256 id) external view returns (HazardClause memory) {
        return clauses[id];
    }
}
