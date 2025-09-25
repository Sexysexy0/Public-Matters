// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title DefenseAcquisitionAccelerationProtocol
/// @notice Ritualizes acceleration of U.S. defense procurement to restore parity with China
/// @dev Anchors override immunity, innovation velocity, and emotional consequence

contract DefenseAcquisitionAccelerationProtocol {
    address public steward;
    mapping(address => bool) public accelerators;

    modifier onlySteward() {
        require(msg.sender == steward, "Not steward");
        _;
    }

    modifier onlyAccelerator() {
        require(accelerators[msg.sender] || msg.sender == steward, "Not accelerator");
        _;
    }

    struct AcquisitionCorridor {
        uint256 id;
        string techDomain; // e.g., "AI", "Cyber Defense", "Hypersonics"
        string bottleneck; // e.g., "Legacy contracting delays"
        bool overrideRemoved;
        bool accelerationActivated;
        string emotionalTag; // e.g., "Strategic parity restored"
        string restorationClause; // e.g., "We commit to innovation velocity and defense dignity"
        uint256 timestamp;
    }

    uint256 public nextCorridorId = 1;
    mapping(uint256 => AcquisitionCorridor) public corridors;

    event AcceleratorSet(address indexed account, bool status);
    event AcquisitionAccelerated(uint256 indexed id, string techDomain, string emotionalTag);

    constructor() {
        steward = msg.sender;
        accelerators[msg.sender] = true;
        emit AcceleratorSet(msg.sender, true);
    }

    function setAccelerator(address account, bool status) external onlySteward {
        accelerators[account] = status;
        emit AcceleratorSet(account, status);
    }

    function accelerateAcquisition(
        string calldata techDomain,
        string calldata bottleneck,
        string calldata emotionalTag,
        string calldata restorationClause
    ) external onlyAccelerator returns (uint256 id) {
        id = nextCorridorId++;
        corridors[id] = AcquisitionCorridor({
            id: id,
            techDomain: techDomain,
            bottleneck: bottleneck,
            overrideRemoved: true,
            accelerationActivated: true,
            emotionalTag: emotionalTag,
            restorationClause: restorationClause,
            timestamp: block.timestamp
        });
        emit AcquisitionAccelerated(id, techDomain, emotionalTag);
    }

    function getAcquisitionCorridor(uint256 id) external view returns (AcquisitionCorridor memory) {
        return corridors[id];
    }
}
