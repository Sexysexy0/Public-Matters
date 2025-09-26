// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title InformationIntegrityProtocol
/// @notice Ritualizes truth defense and restores validator-grade civic clarity across media, governance, and education
/// @dev Anchors emotional consequence mapping, misinformation breach tagging, and speech sovereignty

contract InformationIntegrityProtocol {
    address public steward;
    mapping(address => bool) public validators;

    modifier onlySteward() { require(msg.sender == steward, "Not steward"); _; }
    modifier onlyValidator() { require(validators[msg.sender] || msg.sender == steward, "Not validator"); _; }

    struct IntegrityClause {
        uint256 id;
        string domain; // e.g., "Media", "Education", "Governance", "Social Platforms"
        string breachTrigger; // e.g., "Disinformation", "Censorship", "Algorithmic suppression"
        string emotionalTag; // e.g., "Truth sanctum breach ritualized"
        string restorationAction; // e.g., "Activate fact-check sanctums and speech sovereignty protocols"
        string clarityClause; // e.g., "We restore validator-grade civic clarity and emotional consequence mapping"
        uint256 timestamp;
    }

    uint256 public nextId = 1;
    mapping(uint256 => IntegrityClause> public clauses;

    event ValidatorSet(address indexed account, bool status);
    event IntegrityClauseActivated(uint256 indexed id, string domain, string emotionalTag);

    constructor() {
        steward = msg.sender;
        validators[msg.sender] = true;
        emit ValidatorSet(msg.sender, true);
    }

    function setValidator(address account, bool status) external onlySteward {
        validators[account] = status;
        emit ValidatorSet(account, status);
    }

    function activateIntegrityClause(
        string calldata domain,
        string calldata breachTrigger,
        string calldata emotionalTag,
        string calldata restorationAction,
        string calldata clarityClause
    ) external onlyValidator returns (uint256 id) {
        id = nextId++;
        clauses[id] = IntegrityClause({
            id: id,
            domain: domain,
            breachTrigger: breachTrigger,
            emotionalTag: emotionalTag,
            restorationAction: restorationAction,
            clarityClause: clarityClause,
            timestamp: block.timestamp
        });
        emit IntegrityClauseActivated(id, domain, emotionalTag);
    }

    function getIntegrityClause(uint256 id) external view returns (IntegrityClause memory) {
        return clauses[id];
    }
}
