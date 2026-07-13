// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Creator Mythos
/// @notice Defines eternal mythos-level creative identity; prevents corporate distortion, dilution, or symbolic erasure
contract CreatorMythos {
    address public guardian;
    uint256 public mythosCount;
    uint256 public violationCount;

    enum RoleType {
        Creator,
        Manager,
        Executive,
        Publisher,
        Subcontractor
    }

    enum MythosType {
        OriginMyth,
        WorldMyth,
        CharacterMyth,
        CosmicMyth,
        CulturalMyth,
        ArtisticMyth,
        NarrativeMyth,
        GameplayMyth
    }

    struct MythosEntry {
        uint256 id;
        MythosType mythosType;
        string description;
        address creatorOwner;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct Violation {
        uint256 id;
        address violator;
        RoleType role;
        MythosType mythosType;
        string details;
        uint256 timestamp;
    }

    mapping(uint256 => MythosEntry) public mythos;
    mapping(uint256 => Violation) public violations;
    mapping(address => RoleType) public roles;

    event GuardianChanged(address indexed oldGuardian, address indexed newGuardian);
    event RoleAssigned(address indexed account, RoleType role);
    event MythosDeclared(uint256 indexed id, MythosType mythosType, address creatorOwner);
    event MythosLocked(uint256 indexed id);
    event ViolationLogged(uint256 indexed id, address violator, MythosType mythosType);

    constructor() {
        guardian = msg.sender;
        mythosCount = 0;
        violationCount = 0;

        _declareDefaultMythos();
    }

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Not authorized");
        _;
    }

    modifier onlyCreator() {
        require(roles[msg.sender] == RoleType.Creator, "Creator only");
        _;
    }

    function _declareDefaultMythos() internal {
        _declareMythos(MythosType.OriginMyth, "The origin myth of the studio universe", guardian);
        _declareMythos(MythosType.WorldMyth, "The mythic foundation of the world", guardian);
        _declareMythos(MythosType.CharacterMyth, "Mythic identity of core characters", guardian);
        _declareMythos(MythosType.CosmicMyth, "Cosmic-level mythos and metaphysics", guardian);
        _declareMythos(MythosType.CulturalMyth, "Cultural mythos of the studio", guardian);
        _declareMythos(MythosType.ArtisticMyth, "Mythic artistic identity", guardian);
        _declareMythos(MythosType.NarrativeMyth, "Mythic narrative identity", guardian);
        _declareMythos(MythosType.GameplayMyth, "Mythic gameplay identity", guardian);
    }

    function _declareMythos(
        MythosType mythosType,
        string memory description,
        address creatorOwner
    ) internal {
        mythosCount++;
        mythos[mythosCount] = MythosEntry(
            mythosCount,
            mythosType,
            description,
            creatorOwner,
            false,
            block.timestamp
        );

        emit MythosDeclared(mythosCount, mythosType, creatorOwner);
    }

    function assignRole(address account, RoleType role) external onlyGuardian {
        roles[account] = role;
        emit RoleAssigned(account, role);
    }

    function declareMythos(
        MythosType mythosType,
        string calldata description,
        address creatorOwner
    ) external onlyGuardian {
        require(roles[creatorOwner] == RoleType.Creator, "Owner must be creator");
        _declareMythos(mythosType, description, creatorOwner);
    }

    function lockMythos(uint256 id) external onlyCreator {
        MythosEntry storage m = mythos[id];
        require(!m.immutableEntry, "Already immutable");
        require(m.creatorOwner == msg.sender, "Not owner");

        m.immutableEntry = true;
        emit MythosLocked(id);
    }

    function attemptMythosRewrite(
        uint256 mythosId,
        string calldata details
    ) external {
        RoleType role = roles[msg.sender];
        MythosEntry storage m = mythos[mythosId];

        if (role != RoleType.Creator) {
            _logViolation(msg.sender, role, m.mythosType, details);
        }
    }

    function _logViolation(
        address violator,
        RoleType role,
        MythosType mythosType,
        string memory details
    ) internal {
        violationCount++;
        violations[violationCount] = Violation(
            violationCount,
            violator,
            role,
            mythosType,
            details,
            block.timestamp
        );

        emit ViolationLogged(violationCount, violator, mythosType);
    }

    function changeGuardian(address newGuardian) external onlyGuardian {
        require(newGuardian != address(0), "Invalid guardian");
        emit GuardianChanged(guardian, newGuardian);
        guardian = newGuardian;
    }
}
