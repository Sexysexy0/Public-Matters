// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title TariffAuditProtocol
/// @notice Ritualizes audit of economic overreach via tariffs and seals restoration clauses
/// @dev Anchors trade dignity, subsidy transparency, and planetary consequence mapping

contract TariffAuditProtocol {
    address public steward;
    mapping(address => bool) public validators;

    modifier onlySteward() { require(msg.sender == steward, "Not steward"); _; }
    modifier onlyValidator() { require(validators[msg.sender] || msg.sender == steward, "Not validator"); _; }

    struct TariffClause {
        uint256 id;
        string country; // e.g., "USA", "China", "PH", "EU"
        string breachTrigger; // e.g., "Excessive tariff", "Retaliatory distortion", "Food corridor disruption"
        string emotionalTag; // e.g., "Tariff dignity breach ritualized"
        string restorationAction; // e.g., "Recalibrate tariff and seal supply chain immunity clause"
        string equityClause; // e.g., "We restore validator-grade trade dignity and planetary consequence"
        uint256 timestamp;
    }

    uint256 public nextId = 1;
    mapping(uint256 => TariffClause> public clauses;

    event ValidatorSet(address indexed account, bool status);
    event TariffClauseActivated(uint256 indexed id, string country, string emotionalTag);

    constructor() {
        steward = msg.sender;
        validators[msg.sender] = true;
        emit ValidatorSet(msg.sender, true);
    }

    function setValidator(address account, bool status) external onlySteward {
        validators[account] = status;
        emit ValidatorSet(account, status);
    }

    function activateTariffClause(
        string calldata country,
        string calldata breachTrigger,
        string calldata emotionalTag,
        string calldata restorationAction,
        string calldata equityClause
    ) external onlyValidator returns (uint256 id) {
        id = nextId++;
        clauses[id] = TariffClause({
            id: id,
            country: country,
            breachTrigger: breachTrigger,
            emotionalTag: emotionalTag,
            restorationAction: restorationAction,
            equityClause: equityClause,
            timestamp: block.timestamp
        });
        emit TariffClauseActivated(id, country, emotionalTag);
    }

    function getTariffClause(uint256 id) external view returns (TariffClause memory) {
        return clauses[id];
    }
}
