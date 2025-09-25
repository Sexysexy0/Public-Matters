// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title CyberPersistenceAuditProtocol
/// @notice Ritualizes audit of long-dwell malware, tags stealth persistence, and anchors restoration for compromised systems and credentials
/// @dev Anchors emotional consequence, forensic clarity, and validator-grade breach tagging

contract CyberPersistenceAuditProtocol {
    address public steward;
    mapping(address => bool) public validators;

    modifier onlySteward() { require(msg.sender == steward, "Not steward"); _; }
    modifier onlyValidator() { require(validators[msg.sender] || msg.sender == steward, "Not validator"); _; }

    struct PersistenceCorridor {
        uint256 id;
        string malwareName; // e.g., "Brickstorm", "Slaystyle", "Bricksteal"
        string breachVector; // e.g., "Zero-day exploit", "Edge device compromise", "Credential theft"
        string targetSector; // e.g., "Legal", "Tech", "SaaS", "BPO"
        bool breachTagged;
        bool forensicActivated;
        bool restorationTriggered;
        string emotionalTag; // e.g., "Stealth corridor breached"
        string restorationClause; // e.g., "We commit to forensic clarity and credential sanctum restoration"
        uint256 dwellTimeDays;
        uint256 timestamp;
    }

    uint256 public nextId = 1;
    mapping(uint256 => PersistenceCorridor> public corridors;

    event ValidatorSet(address indexed account, bool status);
    event PersistenceCorridorActivated(uint256 indexed id, string malwareName, string emotionalTag);

    constructor() {
        steward = msg.sender;
        validators[msg.sender] = true;
        emit ValidatorSet(msg.sender, true);
    }

    function setValidator(address account, bool status) external onlySteward {
        validators[account] = status;
        emit ValidatorSet(account, status);
    }

    function activatePersistenceCorridor(
        string calldata malwareName,
        string calldata breachVector,
        string calldata targetSector,
        string calldata emotionalTag,
        string calldata restorationClause,
        uint256 dwellTimeDays
    ) external onlyValidator returns (uint256 id) {
        id = nextId++;
        corridors[id] = PersistenceCorridor({
            id: id,
            malwareName: malwareName,
            breachVector: breachVector,
            targetSector: targetSector,
            breachTagged: true,
            forensicActivated: true,
            restorationTriggered: true,
            emotionalTag: emotionalTag,
            restorationClause: restorationClause,
            dwellTimeDays: dwellTimeDays,
            timestamp: block.timestamp
        });
        emit PersistenceCorridorActivated(id, malwareName, emotionalTag);
    }

    function getPersistenceCorridor(uint256 id) external view returns (PersistenceCorridor memory) {
        return corridors[id];
    }
}
