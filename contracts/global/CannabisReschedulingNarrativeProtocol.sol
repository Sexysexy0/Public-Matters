// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title CannabisReschedulingNarrativeProtocol
/// @notice Ritualizes political framing, anchors emotional consequence, and audits timing calculus behind cannabis rescheduling
/// @dev Anchors validator-grade reform integrity and narrative control detection

contract CannabisReschedulingNarrativeProtocol {
    address public steward;
    mapping(address => bool) public validators;

    modifier onlySteward() { require(msg.sender == steward, "Not steward"); _; }
    modifier onlyValidator() { require(validators[msg.sender] || msg.sender == steward, "Not validator"); _; }

    struct ReschedulingClause {
        uint256 id;
        string jurisdiction; // e.g., "United States"
        string narrativeDriver; // e.g., "Political timing", "Law-and-order framing"
        string impactSummary; // e.g., "Rescheduling framed as Republican win, not health reform"
        string emotionalTag; // e.g., "Cannabis sanctum politicized"
        string timingCalculus; // e.g., "Election cycle alignment, donor pressure, public polling"
        string restorationClause; // e.g., "We commit to science-based reform and dignity-certified cannabis policy"
        uint256 timestamp;
    }

    uint256 public nextId = 1;
    mapping(uint256 => ReschedulingClause> public clauses;

    event ValidatorSet(address indexed account, bool status);
    event ReschedulingClauseActivated(uint256 indexed id, string jurisdiction, string emotionalTag);

    constructor() {
        steward = msg.sender;
        validators[msg.sender] = true;
        emit ValidatorSet(msg.sender, true);
    }

    function setValidator(address account, bool status) external onlySteward {
        validators[account] = status;
        emit ValidatorSet(account, status);
    }

    function activateReschedulingClause(
        string calldata jurisdiction,
        string calldata narrativeDriver,
        string calldata impactSummary,
        string calldata emotionalTag,
        string calldata timingCalculus,
        string calldata restorationClause
    ) external onlyValidator returns (uint256 id) {
        id = nextId++;
        clauses[id] = ReschedulingClause({
            id: id,
            jurisdiction: jurisdiction,
            narrativeDriver: narrativeDriver,
            impactSummary: impactSummary,
            emotionalTag: emotionalTag,
            timingCalculus: timingCalculus,
            restorationClause: restorationClause,
            timestamp: block.timestamp
        });
        emit ReschedulingClauseActivated(id, jurisdiction, emotionalTag);
    }

    function getReschedulingClause(uint256 id) external view returns (ReschedulingClause memory) {
        return clauses[id];
    }
}
