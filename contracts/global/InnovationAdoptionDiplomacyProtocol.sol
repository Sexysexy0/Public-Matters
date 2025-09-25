// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title InnovationAdoptionDiplomacyProtocol
/// @notice Ritualizes diplomatic adoption of foreign inventions, anchors emotional consequence, and restores planetary innovation equity
/// @dev Anchors validator-grade collaboration, dignity credit, and treaty-grade consequence

contract InnovationAdoptionDiplomacyProtocol {
    address public steward;
    mapping(address => bool) public validators;

    modifier onlySteward() { require(msg.sender == steward, "Not steward"); _; }
    modifier onlyValidator() { require(validators[msg.sender] || msg.sender == steward, "Not validator"); _; }

    struct AdoptionClause {
        uint256 id;
        string hostNation; // e.g., "United States"
        string foreignInnovation; // e.g., "Forever Vehicle from Harare"
        string inventorNation; // e.g., "Zimbabwe"
        bool adoptionActivated;
        bool diplomaticDealRequired;
        bool emotionalTagged;
        string emotionalTag; // e.g., "Innovation sanctum honored"
        string restorationClause; // e.g., "We commit to treaty-grade adoption and inventor dignity"
        uint256 timestamp;
    }

    uint256 public nextId = 1;
    mapping(uint256 => AdoptionClause> public clauses;

    event ValidatorSet(address indexed account, bool status);
    event AdoptionClauseActivated(uint256 indexed id, string hostNation, string emotionalTag);

    constructor() {
        steward = msg.sender;
        validators[msg.sender] = true;
        emit ValidatorSet(msg.sender, true);
    }

    function setValidator(address account, bool status) external onlySteward {
        validators[account] = status;
        emit ValidatorSet(account, status);
    }

    function activateAdoptionClause(
        string calldata hostNation,
        string calldata foreignInnovation,
        string calldata inventorNation,
        string calldata emotionalTag,
        string calldata restorationClause
    ) external onlyValidator returns (uint256 id) {
        id = nextId++;
        clauses[id] = AdoptionClause({
            id: id,
            hostNation: hostNation,
            foreignInnovation: foreignInnovation,
            inventorNation: inventorNation,
            adoptionActivated: true,
            diplomaticDealRequired: true,
            emotionalTagged: true,
            emotionalTag: emotionalTag,
            restorationClause: restorationClause,
            timestamp: block.timestamp
        });
        emit AdoptionClauseActivated(id, hostNation, emotionalTag);
    }

    function getAdoptionClause(uint256 id) external view returns (AdoptionClause memory) {
        return clauses[id];
    }
}
