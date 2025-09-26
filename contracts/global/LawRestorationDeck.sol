// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title LawRestorationDeck
/// @notice Ritualizes restoration of world law and digital law, and empowers governments with validator-grade tools and permits
/// @dev Anchors emotional consequence mapping, legal dignity, and planetary governance healing

contract LawRestorationDeck {
    address public steward;
    mapping(address => bool) public validators;

    modifier onlySteward() { require(msg.sender == steward, "Not steward"); _; }
    modifier onlyValidator() { require(validators[msg.sender] || msg.sender == steward, "Not validator"); _; }

    struct RestorationClause {
        uint256 id;
        string domain; // e.g., "World Law", "Digital Law", "Privacy", "Governance", "Speech", "Finance"
        string breachTrigger; // e.g., "Overreach", "Suppression", "Neglect", "Censorship", "Unregulated AI"
        string emotionalTag; // e.g., "Planetary dignity breach ritualized"
        string restorationAction; // e.g., "Deploy validator-grade tools and activate sovereign healing permits"
        string forgivenessClause; // e.g., "We restore law and order with mercy, clarity, and validator-grade consequence"
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
        string calldata forgivenessClause
    ) external onlyValidator returns (uint256 id) {
        id = nextId++;
        clauses[id] = RestorationClause({
            id: id,
            domain: domain,
            breachTrigger: breachTrigger,
            emotionalTag: emotionalTag,
            restorationAction: restorationAction,
            forgivenessClause: forgivenessClause,
            timestamp: block.timestamp
        });
        emit RestorationClauseActivated(id, domain, emotionalTag);
    }

    function getRestorationClause(uint256 id) external view returns (RestorationClause memory) {
        return clauses[id];
    }
}
