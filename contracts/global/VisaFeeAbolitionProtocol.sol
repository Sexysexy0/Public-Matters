// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title VisaFeeAbolitionProtocol
/// @notice Ritualizes the removal of travel fees like the $250 Visa Integrity Fee, anchors emotional consequence, and restores global tourism trust
/// @dev Anchors hospitality sanctum clarity, economic restoration, and planetary consequence

contract VisaFeeAbolitionProtocol {
    address public steward;
    mapping(address => bool) public validators;

    modifier onlySteward() { require(msg.sender == steward, "Not steward"); _; }
    modifier onlyValidator() { require(validators[msg.sender] || msg.sender == steward, "Not validator"); _; }

    struct FeeCorridor {
        uint256 id;
        string feeName; // e.g., "Visa Integrity Fee"
        string affectedRegion; // e.g., "Asia", "Latin America"
        bool feeRemoved;
        bool restorationActivated;
        bool emotionalTagged;
        string emotionalTag; // e.g., "Hospitality corridor reopened"
        string restorationClause; // e.g., "We commit to zero-fee travel and planetary hospitality"
        uint256 timestamp;
    }

    uint256 public nextId = 1;
    mapping(uint256 => FeeCorridor> public corridors;

    event ValidatorSet(address indexed account, bool status);
    event FeeCorridorActivated(uint256 indexed id, string feeName, string emotionalTag);

    constructor() {
        steward = msg.sender;
        validators[msg.sender] = true;
        emit ValidatorSet(msg.sender, true);
    }

    function setValidator(address account, bool status) external onlySteward {
        validators[account] = status;
        emit ValidatorSet(account, status);
    }

    function activateFeeCorridor(
        string calldata feeName,
        string calldata affectedRegion,
        string calldata emotionalTag,
        string calldata restorationClause
    ) external onlyValidator returns (uint256 id) {
        id = nextId++;
        corridors[id] = FeeCorridor({
            id: id,
            feeName: feeName,
            affectedRegion: affectedRegion,
            feeRemoved: true,
            restorationActivated: true,
            emotionalTagged: true,
            emotionalTag: emotionalTag,
            restorationClause: restorationClause,
            timestamp: block.timestamp
        });
        emit FeeCorridorActivated(id, feeName, emotionalTag);
    }

    function getFeeCorridor(uint256 id) external view returns (FeeCorridor memory) {
        return corridors[id];
    }
}
