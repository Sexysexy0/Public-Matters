// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Creator Legacy
/// @notice Protects long-term creative legacy; prevents corporate rewriting, distortion, or erasure of creator vision
contract CreatorLegacy {
    address public guardian;
    uint256 public legacyCount;
    uint256 public violationCount;

    enum RoleType {
        Creator,
        Manager,
        Executive,
        Publisher,
        Subcontractor
    }

    enum LegacyType {
        Canon,
        WorldLore,
        CharacterLore,
        ArtStyle,
        NarrativeTone,
        GameplayPhilosophy,
        CulturalIdentity,
        HistoricalRecord
    }

    struct LegacyEntry {
        uint256 id;
        LegacyType legacyType;
        string description;
        address creatorOwner;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct Violation {
        uint256 id;
        address violator;
        RoleType role;
        LegacyType legacyType;
        string details;
        uint256 timestamp;
    }

    mapping(uint256 => LegacyEntry) public legacy;
    mapping(uint256 => Violation) public violations;
    mapping(address => RoleType) public roles;

    event GuardianChanged(address indexed oldGuardian, address indexed newGuardian);
    event RoleAssigned(address indexed account, RoleType role);
    event LegacyDeclared(uint256 indexed id, LegacyType legacyType, address creatorOwner);
    event LegacyLocked(uint256 indexed id);
    event ViolationLogged(uint256 indexed id, address violator, LegacyType legacyType);

    constructor() {
        guardian = msg.sender;
        legacyCount = 0;
        violationCount = 0;

        _declareDefaultLegacy();
    }

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Not authorized");
        _;
    }

    modifier onlyCreator() {
        require(roles[msg.sender] == RoleType.Creator, "Creator only");
        _;
    }

    function _declareDefaultLegacy() internal {
        _declareLegacy(LegacyType.Canon, "Core canon of the studio universe", guardian);
        _declareLegacy(LegacyType.WorldLore, "Foundational world lore", guardian);
        _declareLegacy(LegacyType.CharacterLore, "Foundational character lore", guardian);
        _declareLegacy(LegacyType.ArtStyle, "Signature art style", guardian);
        _declareLegacy(LegacyType.NarrativeTone, "Core narrative tone", guardian);
        _declareLegacy(LegacyType.GameplayPhilosophy, "Gameplay feel and philosophy", guardian);
        _declareLegacy(LegacyType.CulturalIdentity, "Cultural identity of the studio", guardian);
        _declareLegacy(LegacyType.HistoricalRecord, "Historical record of creative decisions", guardian);
    }

    function _declareLegacy(
        LegacyType legacyType,
        string memory description,
        address creatorOwner
    ) internal {
        legacyCount++;
        legacy[legacyCount] = LegacyEntry(
            legacyCount,
            legacyType,
            description,
            creatorOwner,
            false,
            block.timestamp
        );

        emit LegacyDeclared(legacyCount, legacyType, creatorOwner);
    }

    function assignRole(address account, RoleType role) external onlyGuardian {
        roles[account] = role;
        emit RoleAssigned(account, role);
    }

    function declareLegacy(
        LegacyType legacyType,
        string calldata description,
        address creatorOwner
    ) external onlyGuardian {
        require(roles[creatorOwner] == RoleType.Creator, "Owner must be creator");
        _declareLegacy(legacyType, description, creatorOwner);
    }

    function lockLegacy(uint256 id) external onlyCreator {
        LegacyEntry storage l = legacy[id];
        require(!l.immutableEntry, "Already immutable");
        require(l.creatorOwner == msg.sender, "Not owner");

        l.immutableEntry = true;
        emit LegacyLocked(id);
    }

    function attemptRewrite(
        uint256 legacyId,
        string calldata details
    ) external {
        RoleType role = roles[msg.sender];
        LegacyEntry storage l = legacy[legacyId];

        if (role != RoleType.Creator) {
            _logViolation(msg.sender, role, l.legacyType, details);
        }
    }

    function _logViolation(
        address violator,
        RoleType role,
        LegacyType legacyType,
        string memory details
    ) internal {
        violationCount++;
        violations[violationCount] = Violation(
            violationCount,
            violator,
            role,
            legacyType,
            details,
            block.timestamp
        );

        emit ViolationLogged(violationCount, violator, legacyType);
    }

    function changeGuardian(address newGuardian) external onlyGuardian {
        require(newGuardian != address(0), "Invalid guardian");
        emit GuardianChanged(guardian, newGuardian);
        guardian = newGuardian;
    }
}
