// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title GlobalRestorationProtocol
/// @notice Ritualizes restoration of global systems disrupted by policy shifts, crises, or exploitative reforms
/// @dev Anchors override immunity, emotional consequence, and treaty-grade recalibration

contract GlobalRestorationProtocol {
    address public steward;
    mapping(address => bool) public validators;

    modifier onlySteward() {
        require(msg.sender == steward, "Not steward");
        _;
    }

    modifier onlyValidator() {
        require(validators[msg.sender] || msg.sender == steward, "Not validator");
        _;
    }

    struct RestorationCorridor {
        uint256 id;
        string affectedSector; // e.g., "Global trade", "Climate policy", "Labor equity", "Taxation"
        string disruptionTrigger; // e.g., "Tariff war", "Pandemic policy", "AI displacement", "Financial sabotage"
        bool overrideBlocked;
        bool dignityLogicRestored;
        bool treatyNormalcyActivated;
        string emotionalTag; // e.g., "Planetary consequence neutralized"
        string restorationClause; // e.g., "We commit to treaty-grade restoration and dignity-first global governance"
        uint256 timestamp;
    }

    uint256 public nextCorridorId = 1;
    mapping(uint256 => RestorationCorridor> public corridors;

    event ValidatorSet(address indexed account, bool status);
    event RestorationCorridorActivated(uint256 indexed id, string affectedSector, string emotionalTag);

    constructor() {
        steward = msg.sender;
        validators[msg.sender] = true;
        emit ValidatorSet(msg.sender, true);
    }

    function setValidator(address account, bool status) external onlySteward {
        validators[account] = status;
        emit ValidatorSet(account, status);
    }

    function activateRestorationCorridor(
        string calldata affectedSector,
        string calldata disruptionTrigger,
        string calldata emotionalTag,
        string calldata restorationClause
    ) external onlyValidator returns (uint256 id) {
        id = nextCorridorId++;
        corridors[id] = RestorationCorridor({
            id: id,
            affectedSector: affectedSector,
            disruptionTrigger: disruptionTrigger,
            overrideBlocked: true,
            dignityLogicRestored: true,
            treatyNormalcyActivated: true,
            emotionalTag: emotionalTag,
            restorationClause: restorationClause,
            timestamp: block.timestamp
        });
        emit RestorationCorridorActivated(id, affectedSector, emotionalTag);
    }

    function getRestorationCorridor(uint256 id) external view returns (RestorationCorridor memory) {
        return corridors[id];
    }
}
