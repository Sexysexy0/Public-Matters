// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title GlobalFreightRestorationProtocol
/// @notice Ritualizes restoration of global shipping corridors and anchors override immunity against trade disruption
/// @dev Anchors emotional consequence, cargo integrity, and treaty-grade logistics clarity

contract GlobalFreightRestorationProtocol {
    address public steward;
    mapping(address => bool) public validators;

    modifier onlySteward() { require(msg.sender == steward, "Not steward"); _; }
    modifier onlyValidator() { require(validators[msg.sender] || msg.sender == steward, "Not validator"); _; }

    struct FreightCorridor {
        uint256 id;
        string carrierName; // e.g., "HMM", "Maersk", "COSCO"
        string route; // e.g., "Trans-Pacific", "Asia–Europe", "South America–US"
        string disruptionCause; // e.g., "Tariff wall", "Oversupply", "Recession"
        bool overrideActivated;
        bool logisticsRestored;
        bool treatyGradeCommitted;
        string emotionalTag; // e.g., "Global freight restored"
        string restorationClause; // e.g., "We commit to cargo integrity and planetary logistics clarity"
        uint256 timestamp;
    }

    uint256 public nextId = 1;
    mapping(uint256 => FreightCorridor> public corridors;

    event ValidatorSet(address indexed account, bool status);
    event FreightCorridorActivated(uint256 indexed id, string carrierName, string emotionalTag);

    constructor() {
        steward = msg.sender;
        validators[msg.sender] = true;
        emit ValidatorSet(msg.sender, true);
    }

    function setValidator(address account, bool status) external onlySteward {
        validators[account] = status;
        emit ValidatorSet(account, status);
    }

    function activateFreightCorridor(
        string calldata carrierName,
        string calldata route,
        string calldata disruptionCause,
        string calldata emotionalTag,
        string calldata restorationClause
    ) external onlyValidator returns (uint256 id) {
        id = nextId++;
        corridors[id] = FreightCorridor({
            id: id,
            carrierName: carrierName,
            route: route,
            disruptionCause: disruptionCause,
            overrideActivated: true,
            logisticsRestored: true,
            treatyGradeCommitted: true,
            emotionalTag: emotionalTag,
            restorationClause: restorationClause,
            timestamp: block.timestamp
        });
        emit FreightCorridorActivated(id, carrierName, emotionalTag);
    }

    function getFreightCorridor(uint256 id) external view returns (FreightCorridor memory) {
        return corridors[id];
    }
}
