// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract AIEnvironmentalImpactProtocol {
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

    struct ImpactCorridor {
        uint256 id;
        string dataCenter;
        string emissionSource; // e.g., "Grid overload", "Non-renewable spike"
        bool transparencyActivated;
        bool emissionTagged;
        string emotionalTag; // e.g., "Planetary consequence mapped"
        string restorationClause;
        uint256 timestamp;
    }

    uint256 public nextCorridorId = 1;
    mapping(uint256 => ImpactCorridor> public corridors;

    event ValidatorSet(address indexed account, bool status);
    event ImpactCorridorActivated(uint256 indexed id, string dataCenter, string emotionalTag);

    constructor() {
        steward = msg.sender;
        validators[msg.sender] = true;
        emit ValidatorSet(msg.sender, true);
    }

    function setValidator(address account, bool status) external onlySteward {
        validators[account] = status;
        emit ValidatorSet(account, status);
    }

    function activateImpactCorridor(
        string calldata dataCenter,
        string calldata emissionSource,
        string calldata emotionalTag,
        string calldata restorationClause
    ) external onlyValidator returns (uint256 id) {
        id = nextCorridorId++;
        corridors[id] = ImpactCorridor({
            id: id,
            dataCenter: dataCenter,
            emissionSource: emissionSource,
            transparencyActivated: true,
            emissionTagged: true,
            emotionalTag: emotionalTag,
            restorationClause: restorationClause,
            timestamp: block.timestamp
        });
        emit ImpactCorridorActivated(id, dataCenter, emotionalTag);
    }

    function getImpactCorridor(uint256 id) external view returns (ImpactCorridor memory) {
        return corridors[id];
    }
}
