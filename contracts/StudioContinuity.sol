// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Studio Continuity
/// @notice Ensures continuity of creative vision across decades; blocks corporate resets, reboots, and direction hijacks
contract StudioContinuity {
    address public guardian;
    uint256 public continuityPointCount;
    uint256 public violationCount;

    enum RoleType {
        Creator,
        Manager,
        Executive,
        Publisher,
        Subcontractor
    }

    enum ContinuityType {
        VisionPillar,
        ArtIdentity,
        NarrativeIdentity,
        WorldIdentity,
        GameplayIdentity,
        CulturalIdentity,
        StudioPhilosophy,
        LongTermRoadmap
    }

    struct ContinuityPoint {
        uint256 id;
        ContinuityType continuityType;
        string description;
        address creatorOwner;
        bool immutablePoint;
        uint256 timestamp;
    }

    struct Violation {
        uint256 id;
        address violator;
        RoleType role;
        ContinuityType continuityType;
        string details;
        uint256 timestamp;
    }

    mapping(uint256 => ContinuityPoint> public continuity;
    mapping(uint256 => Violation> public violations;
    mapping(address => RoleType> public roles;

    event GuardianChanged(address indexed oldGuardian, address indexed newGuardian);
    event RoleAssigned(address indexed account, RoleType role);
    event ContinuityDeclared(uint256 indexed id, ContinuityType continuityType, address creatorOwner);
    event ContinuityLocked(uint256 indexed id);
    event ViolationLogged(uint256 indexed id, address violator, ContinuityType continuityType);

    constructor() {
        guardian = msg.sender;
        continuityPointCount = 0;
        violationCount = 0;

        _declareDefaultContinuity();
    }

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Not authorized");
        _;
    }

    modifier onlyCreator() {
        require(roles[msg.sender] == RoleType.Creator, "Creator only");
        _;
    }

    function _declareDefaultContinuity() internal {
        _declareContinuity(ContinuityType.VisionPillar, "Core vision pillars of the studio", guardian);
        _declareContinuity(ContinuityType.ArtIdentity, "Signature art identity", guardian);
        _declareContinuity(ContinuityType.NarrativeIdentity, "Narrative identity and tone", guardian);
        _declareContinuity(ContinuityType.WorldIdentity, "World identity and foundational lore", guardian);
        _declareContinuity(ContinuityType.GameplayIdentity, "Gameplay identity and philosophy", guardian);
        _declareContinuity(ContinuityType.CulturalIdentity, "Cultural identity of the studio", guardian);
        _declareContinuity(ContinuityType.StudioPhilosophy, "Studio philosophy and values", guardian);
        _declareContinuity(ContinuityType.LongTermRoadmap, "Long-term creative roadmap", guardian);
    }

    function _declareContinuity(
        ContinuityType continuityType,
        string memory description,
        address creatorOwner
    ) internal {
        continuityPointCount++;
        continuity[continuityPointCount] = ContinuityPoint(
            continuityPointCount,
            continuityType,
            description,
            creatorOwner,
            false,
            block.timestamp
        );

        emit ContinuityDeclared(continuityPointCount, continuityType, creatorOwner);
    }

    function assignRole(address account, RoleType role) external onlyGuardian {
        roles[account] = role;
        emit RoleAssigned(account, role);
    }

    function declareContinuity(
        ContinuityType continuityType,
        string calldata description,
        address creatorOwner
    ) external onlyGuardian {
        require(roles[creatorOwner] == RoleType.Creator, "Owner must be creator");
        _declareContinuity(continuityType, description, creatorOwner);
    }

    function lockContinuity(uint256 id) external onlyCreator {
        ContinuityPoint storage c = continuity[id];
        require(!c.immutablePoint, "Already immutable");
        require(c.creatorOwner == msg.sender, "Not owner");

        c.immutablePoint = true;
        emit ContinuityLocked(id);
    }

    function attemptReset(
        uint256 continuityId,
        string calldata details
    ) external {
        RoleType role = roles[msg.sender];
        ContinuityPoint storage c = continuity[continuityId];

        if (role != RoleType.Creator) {
            _logViolation(msg.sender, role, c.continuityType, details);
        }
    }

    function _logViolation(
        address violator,
        RoleType role,
        ContinuityType continuityType,
        string memory details
    ) internal {
        violationCount++;
        violations[violationCount] = Violation(
            violationCount,
            violator,
            role,
            continuityType,
            details,
            block.timestamp
        );

        emit ViolationLogged(violationCount, violator, continuityType);
    }

    function changeGuardian(address newGuardian) external onlyGuardian {
        require(newGuardian != address(0), "Invalid guardian");
        emit GuardianChanged(guardian, newGuardian);
        guardian = newGuardian;
    }
}
