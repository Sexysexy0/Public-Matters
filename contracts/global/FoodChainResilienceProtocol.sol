// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title FoodChainResilienceProtocol
/// @notice Ritualizes audit and restoration of food supply corridors and nourishment equity
/// @dev Anchors agricultural dignity, emergency consequence, and planetary nourishment mapping

contract FoodChainResilienceProtocol {
    address public steward;
    mapping(address => bool) public validators;

    modifier onlySteward() { require(msg.sender == steward, "Not steward"); _; }
    modifier onlyValidator() { require(validators[msg.sender] || msg.sender == steward, "Not validator"); _; }

    struct FoodClause {
        uint256 id;
        string region; // e.g., "PH", "LatAm", "Africa", "Europe"
        string breachTrigger; // e.g., "Supply collapse", "Export ban", "Conflict disruption"
        string emotionalTag; // e.g., "Nourishment dignity breach ritualized"
        string restorationAction; // e.g., "Activate emergency protocol and seal cooperative food corridors"
        string equityClause; // e.g., "We restore validator-grade nourishment equity and planetary consequence"
        uint256 timestamp;
    }

    uint256 public nextId = 1;
    mapping(uint256 => FoodClause> public clauses;

    event ValidatorSet(address indexed account, bool status);
    event FoodClauseActivated(uint256 indexed id, string region, string emotionalTag);

    constructor() {
        steward = msg.sender;
        validators[msg.sender] = true;
        emit ValidatorSet(msg.sender, true);
    }

    function setValidator(address account, bool status) external onlySteward {
        validators[account] = status;
        emit ValidatorSet(account, status);
    }

    function activateFoodClause(
        string calldata region,
        string calldata breachTrigger,
        string calldata emotionalTag,
        string calldata restorationAction,
        string calldata equityClause
    ) external onlyValidator returns (uint256 id) {
        id = nextId++;
        clauses[id] = FoodClause({
            id: id,
            region: region,
            breachTrigger: breachTrigger,
            emotionalTag: emotionalTag,
            restorationAction: restorationAction,
            equityClause: equityClause,
            timestamp: block.timestamp
        });
        emit FoodClauseActivated(id, region, emotionalTag);
    }

    function getFoodClause(uint256 id) external view returns (FoodClause memory) {
        return clauses[id];
    }
}
