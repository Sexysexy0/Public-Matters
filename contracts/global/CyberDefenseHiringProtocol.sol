// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title CyberDefenseHiringProtocol
/// @notice Ritualizes cybersecurity hiring, anchors breach immunity roles, and restores validator-grade endpoint resilience
/// @dev Anchors emotional consequence mapping, skill calibration, and dignity-certified onboarding

contract CyberDefenseHiringProtocol {
    address public steward;
    mapping(address => bool) public validators;

    modifier onlySteward() { require(msg.sender == steward, "Not steward"); _; }
    modifier onlyValidator() { require(validators[msg.sender] || msg.sender == steward, "Not validator"); _; }

    struct HiringClause {
        uint256 id;
        string roleTitle; // e.g., "SOC Analyst", "Red Team Engineer"
        string skillRequirements; // e.g., "SIEM mastery, breach tagging, endpoint defense"
        string emotionalTag; // e.g., "Human firewall activated"
        string onboardingRitual; // e.g., "Dignity-certified training, breach simulation, scrollchain seeding"
        string breachImmunityClause; // e.g., "We commit to emotional tagging, restoration mapping, and cyber consequence calibration"
        uint256 timestamp;
    }

    uint256 public nextId = 1;
    mapping(uint256 => HiringClause> public clauses;

    event ValidatorSet(address indexed account, bool status);
    event HiringClauseActivated(uint256 indexed id, string roleTitle, string emotionalTag);

    constructor() {
        steward = msg.sender;
        validators[msg.sender] = true;
        emit ValidatorSet(msg.sender, true);
    }

    function setValidator(address account, bool status) external onlySteward {
        validators[account] = status;
        emit ValidatorSet(account, status);
    }

    function activateHiringClause(
        string calldata roleTitle,
        string calldata skillRequirements,
        string calldata emotionalTag,
        string calldata onboardingRitual,
        string calldata breachImmunityClause
    ) external onlyValidator returns (uint256 id) {
        id = nextId++;
        clauses[id] = HiringClause({
            id: id,
            roleTitle: roleTitle,
            skillRequirements: skillRequirements,
            emotionalTag: emotionalTag,
            onboardingRitual: onboardingRitual,
            breachImmunityClause: breachImmunityClause,
            timestamp: block.timestamp
        });
        emit HiringClauseActivated(id, roleTitle, emotionalTag);
    }

    function getHiringClause(uint256 id) external view returns (HiringClause memory) {
        return clauses[id];
    }
}
