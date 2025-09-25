// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title LibertySanctumOverrideProtocol
/// @notice Ritualizes override immunity for cannabis and firearm policy breaches, clears nonviolent violations, and restores rights for responsible citizens
/// @dev Anchors emotional consequence, red tape removal, and dignity-certified access

contract LibertySanctumOverrideProtocol {
    address public steward;
    mapping(address => bool) public validators;

    modifier onlySteward() { require(msg.sender == steward, "Not steward"); _; }
    modifier onlyValidator() { require(validators[msg.sender] || msg.sender == steward, "Not validator"); _; }

    struct OverrideCorridor {
        uint256 id;
        string citizenName;
        string sector; // e.g., "Cannabis", "Firearm", "Dual-use"
        string violationType; // e.g., "Nonviolent possession", "Administrative delay", "Red tape block"
        bool overrideActivated;
        bool violationCleared;
        bool redTapeRemoved;
        bool rightsRestored;
        string emotionalTag; // e.g., "Liberty corridor restored"
        string restorationClause; // e.g., "We commit to dignity-certified access and constitutional consequence"
        uint256 timestamp;
    }

    uint256 public nextId = 1;
    mapping(uint256 => OverrideCorridor> public corridors;

    event ValidatorSet(address indexed account, bool status);
    event OverrideCorridorActivated(uint256 indexed id, string citizenName, string emotionalTag);

    constructor() {
        steward = msg.sender;
        validators[msg.sender] = true;
        emit ValidatorSet(msg.sender, true);
    }

    function setValidator(address account, bool status) external onlySteward {
        validators[account] = status;
        emit ValidatorSet(account, status);
    }

    function activateOverrideCorridor(
        string calldata citizenName,
        string calldata sector,
        string calldata violationType,
        string calldata emotionalTag,
        string calldata restorationClause
    ) external onlyValidator returns (uint256 id) {
        id = nextId++;
        corridors[id] = OverrideCorridor({
            id: id,
            citizenName: citizenName,
            sector: sector,
            violationType: violationType,
            overrideActivated: true,
            violationCleared: true,
            redTapeRemoved: true,
            rightsRestored: true,
            emotionalTag: emotionalTag,
            restorationClause: restorationClause,
            timestamp: block.timestamp
        });
        emit OverrideCorridorActivated(id, citizenName, emotionalTag);
    }

    function getOverrideCorridor(uint256 id) external view returns (OverrideCorridor memory) {
        return corridors[id];
    }
}
