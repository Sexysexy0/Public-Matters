// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Creator Canon
/// @notice Defines immutable creative canon; prevents corporate rewriting, distortion, or retconning of the universe
contract CreatorCanon {
    address public guardian;
    uint256 public canonCount;
    uint256 public violationCount;

    enum RoleType {
        Creator,
        Manager,
        Executive,
        Publisher,
        Subcontractor
    }

    enum CanonType {
        FoundationalLore,
        WorldRules,
        CharacterRules,
        TimelineRules,
        ArtIdentity,
        NarrativeIdentity,
        GameplayIdentity,
        CulturalIdentity
    }

    struct CanonEntry {
        uint256 id;
        CanonType canonType;
        string description;
        address creatorOwner;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct Violation {
        uint256 id;
        address violator;
        RoleType role;
        CanonType canonType;
        string details;
        uint256 timestamp;
    }

    mapping(uint256 => CanonEntry) public canon;
    mapping(uint256 => Violation) public violations;
    mapping(address => RoleType) public roles;

    event GuardianChanged(address indexed oldGuardian, address indexed newGuardian);
    event RoleAssigned(address indexed account, RoleType role);
    event CanonDeclared(uint256 indexed id, CanonType canonType, address creatorOwner);
    event CanonLocked(uint256 indexed id);
    event ViolationLogged(uint256 indexed id, address violator, CanonType canonType);

    constructor() {
        guardian = msg.sender;
        canonCount = 0;
        violationCount = 0;

        _declareDefaultCanon();
    }

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Not authorized");
        _;
    }

    modifier onlyCreator() {
        require(roles[msg.sender] == RoleType.Creator, "Creator only");
        _;
    }

    function _declareDefaultCanon() internal {
        _declareCanon(CanonType.FoundationalLore, "Foundational lore of the universe", guardian);
        _declareCanon(CanonType.WorldRules, "Rules governing the world and physics", guardian);
        _declareCanon(CanonType.CharacterRules, "Rules governing characters and identity", guardian);
        _declareCanon(CanonType.TimelineRules, "Rules governing timeline and continuity", guardian);
        _declareCanon(CanonType.ArtIdentity, "Signature art identity", guardian);
        _declareCanon(CanonType.NarrativeIdentity, "Narrative identity and tone", guardian);
        _declareCanon(CanonType.GameplayIdentity, "Gameplay identity and philosophy", guardian);
        _declareCanon(CanonType.CulturalIdentity, "Cultural identity of the studio universe", guardian);
    }

    function _declareCanon(
        CanonType canonType,
        string memory description,
        address creatorOwner
    ) internal {
        canonCount++;
        canon[canonCount] = CanonEntry(
            canonCount,
            canonType,
            description,
            creatorOwner,
            false,
            block.timestamp
        );

        emit CanonDeclared(canonCount, canonType, creatorOwner);
    }

    function assignRole(address account, RoleType role) external onlyGuardian {
        roles[account] = role;
        emit RoleAssigned(account, role);
    }

    function declareCanon(
        CanonType canonType,
        string calldata description,
        address creatorOwner
    ) external onlyGuardian {
        require(roles[creatorOwner] == RoleType.Creator, "Owner must be creator");
        _declareCanon(canonType, description, creatorOwner);
    }

    function lockCanon(uint256 id) external onlyCreator {
        CanonEntry storage c = canon[id];
        require(!c.immutableEntry, "Already immutable");
        require(c.creatorOwner == msg.sender, "Not owner");

        c.immutableEntry = true;
        emit CanonLocked(id);
    }

    function attemptRetcon(
        uint256 canonId,
        string calldata details
    ) external {
        RoleType role = roles[msg.sender];
        CanonEntry storage c = canon[canonId];

        if (role != RoleType.Creator) {
            _logViolation(msg.sender, role, c.canonType, details);
        }
    }

    function _logViolation(
        address violator,
        RoleType role,
        CanonType canonType,
        string memory details
    ) internal {
        violationCount++;
        violations[violationCount] = Violation(
            violationCount,
            violator,
            role,
            canonType,
            details,
            block.timestamp
        );

        emit ViolationLogged(violationCount, violator, canonType);
    }

    function changeGuardian(address newGuardian) external onlyGuardian {
        require(newGuardian != address(0), "Invalid guardian");
        emit GuardianChanged(guardian, newGuardian);
        guardian = newGuardian;
    }
}
