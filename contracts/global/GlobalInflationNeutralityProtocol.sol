// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title GlobalInflationNeutralityProtocol
/// @notice Ritualizes inflation trigger tagging and planetary price stability restoration
/// @dev Anchors validator-grade economic dignity and monetary breach immunity

contract GlobalInflationNeutralityProtocol {
    address public steward;
    mapping(address => bool) public validators;

    modifier onlySteward() { require(msg.sender == steward, "Not steward"); _; }
    modifier onlyValidator() { require(validators[msg.sender] || msg.sender == steward, "Not validator"); _; }

    struct InflationClause {
        uint256 id;
        string region; // e.g., "Philippines", "United States", "Eurozone"
        string triggerType; // e.g., "Currency dilution", "Supply shock", "Tariff-induced"
        string emotionalTag; // e.g., "Purchasing power breach ritualized"
        string neutralizationAction; // e.g., "Activate monetary restraint, restore fiscal discipline"
        string restorationClause; // e.g., "We restore validator-grade price stability and economic dignity"
        uint256 timestamp;
    }

    uint256 public nextId = 1;
    mapping(uint256 => InflationClause> public clauses;

    event ValidatorSet(address indexed account, bool status);
    event InflationClauseActivated(uint256 indexed id, string region, string emotionalTag);

    constructor() {
        steward = msg.sender;
        validators[msg.sender] = true;
        emit ValidatorSet(msg.sender, true);
    }

    function setValidator(address account, bool status) external onlySteward {
        validators[account] = status;
        emit ValidatorSet(account, status);
    }

    function activateInflationClause(
        string calldata region,
        string calldata triggerType,
        string calldata emotionalTag,
        string calldata neutralizationAction,
        string calldata restorationClause
    ) external onlyValidator returns (uint256 id) {
        id = nextId++;
        clauses[id] = InflationClause({
            id: id,
            region: region,
            triggerType: triggerType,
            emotionalTag: emotionalTag,
            neutralizationAction: neutralizationAction,
            restorationClause: restorationClause,
            timestamp: block.timestamp
        });
        emit InflationClauseActivated(id, region, emotionalTag);
    }

    function getInflationClause(uint256 id) external view returns (InflationClause memory) {
        return clauses[id];
    }
}
