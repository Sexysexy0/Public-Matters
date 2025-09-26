// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title WorldOrderRestorationProtocol
/// @notice Ritualizes global equity, dignity, and consequence through unified validator-grade restoration clauses
/// @dev Anchors planetary stewardship, emotional infrastructure, and treaty-grade cooperation

contract WorldOrderRestorationProtocol {
    address public steward;
    mapping(address => bool) public validators;

    modifier onlySteward() { require(msg.sender == steward, "Not steward"); _; }
    modifier onlyValidator() { require(validators[msg.sender] || msg.sender == steward, "Not validator"); _; }

    struct RestorationClause {
        uint256 id;
        string domain; // e.g., "Climate", "Finance", "Speech", "Migration", "Diplomacy"
        string breachTrigger; // e.g., "Carbon excess", "Banking injustice", "Censorship", "Visa inequity", "Empire dominance"
        string emotionalTag; // e.g., "Planetary dignity breach ritualized"
        string restorationAction; // e.g., "Activate renewable corridors and multipolar cooperation"
        string treatyClause; // e.g., "We restore validator-grade equity, dignity, and planetary consequence"
        uint256 timestamp;
    }

    uint256 public nextId = 1;
    mapping(uint256 => RestorationClause> public clauses;

    event ValidatorSet(address indexed account, bool status);
    event RestorationClauseActivated(uint256 indexed id, string domain, string emotionalTag);

    constructor() {
        steward = msg.sender;
        validators[msg.sender] = true;
        emit ValidatorSet(msg.sender, true);
    }

    function setValidator(address account, bool status) external onlySteward {
        validators[account] = status;
        emit ValidatorSet(account, status);
    }

    function activateRestorationClause(
        string calldata domain,
        string calldata breachTrigger,
        string calldata emotionalTag,
        string calldata restorationAction,
        string calldata treatyClause
    ) external onlyValidator returns (uint256 id) {
        id = nextId++;
        clauses[id] = RestorationClause({
            id: id,
            domain: domain,
            breachTrigger: breachTrigger,
            emotionalTag: emotionalTag,
            restorationAction: restorationAction,
            treatyClause: treatyClause,
            timestamp: block.timestamp
        });
        emit RestorationClauseActivated(id, domain, emotionalTag);
    }

    function getRestorationClause(uint256 id) external view returns (RestorationClause memory) {
        return clauses[id];
    }
}
