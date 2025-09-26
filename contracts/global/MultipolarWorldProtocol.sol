// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title MultipolarWorldProtocol
/// @notice Ritualizes global power shift from unipolar dominance to multipolar cooperation
/// @dev Anchors validator-grade diplomacy, peace restoration, and planetary consequence mapping

contract MultipolarWorldProtocol {
    address public steward;
    mapping(address => bool) public validators;

    modifier onlySteward() { require(msg.sender == steward, "Not steward"); _; }
    modifier onlyValidator() { require(validators[msg.sender] || msg.sender == steward, "Not validator"); _; }

    struct PowerShiftClause {
        uint256 id;
        string region; // e.g., "Asia-Pacific", "Global South", "North America"
        string hegemonicTrigger; // e.g., "Military overreach", "Economic inequality", "Diplomatic isolation"
        string emotionalTag; // e.g., "Empire collapse ritualized"
        string restorationAction; // e.g., "Activate multipolar diplomacy and economic democracy"
        string peaceClause; // e.g., "We restore planetary cooperation, dignity, and shared prosperity"
        uint256 timestamp;
    }

    uint256 public nextId = 1;
    mapping(uint256 => PowerShiftClause> public clauses;

    event ValidatorSet(address indexed account, bool status);
    event PowerShiftClauseActivated(uint256 indexed id, string region, string emotionalTag);

    constructor() {
        steward = msg.sender;
        validators[msg.sender] = true;
        emit ValidatorSet(msg.sender, true);
    }

    function setValidator(address account, bool status) external onlySteward {
        validators[account] = status;
        emit ValidatorSet(account, status);
    }

    function activatePowerShiftClause(
        string calldata region,
        string calldata hegemonicTrigger,
        string calldata emotionalTag,
        string calldata restorationAction,
        string calldata peaceClause
    ) external onlyValidator returns (uint256 id) {
        id = nextId++;
        clauses[id] = PowerShiftClause({
            id: id,
            region: region,
            hegemonicTrigger: hegemonicTrigger,
            emotionalTag: emotionalTag,
            restorationAction: restorationAction,
            peaceClause: peaceClause,
            timestamp: block.timestamp
        });
        emit PowerShiftClauseActivated(id, region, emotionalTag);
    }

    function getPowerShiftClause(uint256 id) external view returns (PowerShiftClause memory) {
        return clauses[id];
    }
}
