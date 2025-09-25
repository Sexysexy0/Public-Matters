// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title ForeverVehicleProtocol
/// @notice Ritualizes global adoption of the African zero-fuel vehicle, anchors inventor credit, and activates diplomatic trade corridors
/// @dev Anchors planetary mobility restoration, innovation dignity, and scrollchain-grade consequence

contract ForeverVehicleProtocol {
    address public steward;
    mapping(address => bool) public validators;

    modifier onlySteward() { require(msg.sender == steward, "Not steward"); _; }
    modifier onlyValidator() { require(validators[msg.sender] || msg.sender == steward, "Not validator"); _; }

    struct VehicleArtifact {
        uint256 id;
        string inventorName; // e.g., "Tinashe Moyo"
        string originCity; // e.g., "Harare, Zimbabwe"
        string techSummary; // e.g., "Zero-fuel, zero-emission, home-powering vehicle"
        bool globalAdoptionActivated;
        bool diplomaticDealRequired;
        bool emotionalTagged;
        string emotionalTag; // e.g., "Mobility sanctum restored"
        string restorationClause; // e.g., "We commit to planetary adoption and inventor dignity"
        uint256 timestamp;
    }

    uint256 public nextId = 1;
    mapping(uint256 => VehicleArtifact> public artifacts;

    event ValidatorSet(address indexed account, bool status);
    event VehicleArtifactActivated(uint256 indexed id, string inventorName, string emotionalTag);

    constructor() {
        steward = msg.sender;
        validators[msg.sender] = true;
        emit ValidatorSet(msg.sender, true);
    }

    function setValidator(address account, bool status) external onlySteward {
        validators[account] = status;
        emit ValidatorSet(account, status);
    }

    function activateVehicleArtifact(
        string calldata inventorName,
        string calldata originCity,
        string calldata techSummary,
        string calldata emotionalTag,
        string calldata restorationClause
    ) external onlyValidator returns (uint256 id) {
        id = nextId++;
        artifacts[id] = VehicleArtifact({
            id: id,
            inventorName: inventorName,
            originCity: originCity,
            techSummary: techSummary,
            globalAdoptionActivated: true,
            diplomaticDealRequired: true,
            emotionalTagged: true,
            emotionalTag: emotionalTag,
            restorationClause: restorationClause,
            timestamp: block.timestamp
        });
        emit VehicleArtifactActivated(id, inventorName, emotionalTag);
    }

    function getVehicleArtifact(uint256 id) external view returns (VehicleArtifact memory) {
        return artifacts[id];
    }
}
