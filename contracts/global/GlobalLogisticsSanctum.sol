// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title GlobalLogisticsSanctum
/// @notice Ritualizes audit and restoration of planetary supply corridors and cargo integrity
/// @dev Anchors treaty-grade delivery, breach tagging, and sovereign logistics consequence

contract GlobalLogisticsSanctum {
    address public steward;
    mapping(address => bool) public validators;

    modifier onlySteward() { require(msg.sender == steward, "Not steward"); _; }
    modifier onlyValidator() { require(validators[msg.sender] || msg.sender == steward, "Not validator"); _; }

    struct LogisticsClause {
        uint256 id;
        string corridor; // e.g., "PH–HK", "LatAm–EU", "US–Africa"
        string breachTrigger; // e.g., "Cargo tampering", "Unverified delivery", "Sanction drift"
        string emotionalTag; // e.g., "Logistics dignity breach ritualized"
        string restorationAction; // e.g., "Seal cargo registry and activate treaty-grade delivery protocol"
        string equityClause; // e.g., "We restore validator-grade logistics equity and planetary consequence"
        uint256 timestamp;
    }

    uint256 public nextId = 1;
    mapping(uint256 => LogisticsClause> public clauses;

    event ValidatorSet(address indexed account, bool status);
    event LogisticsClauseActivated(uint256 indexed id, string corridor, string emotionalTag);

    constructor() {
        steward = msg.sender;
        validators[msg.sender] = true;
        emit ValidatorSet(msg.sender, true);
    }

    function setValidator(address account, bool status) external onlySteward {
        validators[account] = status;
        emit ValidatorSet(account, status);
    }

    function activateLogisticsClause(
        string calldata corridor,
        string calldata breachTrigger,
        string calldata emotionalTag,
        string calldata restorationAction,
        string calldata equityClause
    ) external onlyValidator returns (uint256 id) {
        id = nextId++;
        clauses[id] = LogisticsClause({
            id: id,
            corridor: corridor,
            breachTrigger: breachTrigger,
            emotionalTag: emotionalTag,
            restorationAction: restorationAction,
            equityClause: equityClause,
            timestamp: block.timestamp
        });
        emit LogisticsClauseActivated(id, corridor, emotionalTag);
    }

    function getLogisticsClause(uint256 id) external view returns (LogisticsClause memory) {
        return clauses[id];
    }
}
