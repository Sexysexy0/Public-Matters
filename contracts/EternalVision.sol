// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Eternal Vision
/// @notice Eternal preservation of creator vision; prevents erasure, distortion, override, or future corruption
contract EternalVision {
    address public guardian;
    uint256 public visionCount;
    uint256 public violationCount;

    enum RoleType {
        Creator,
        Manager,
        Executive,
        Publisher,
        Subcontractor,
        FutureEntity // protects against future corporate owners or unknown actors
    }

    enum VisionType {
        PrimeVision,
        CorePhilosophy,
        EternalTheme,
        EternalTone,
        EternalArtIdentity,
        EternalNarrativeIdentity,
        EternalGameplayIdentity,
        EternalWorldIdentity
    }

    struct VisionEntry {
        uint256 id;
        VisionType visionType;
        string description;
        address creatorOwner;
        bool eternalLock;
        uint256 timestamp;
    }

    struct Violation {
        uint256 id;
        address violator;
        RoleType role;
        VisionType visionType;
        string details;
        uint256 timestamp;
    }

    mapping(uint256 => VisionEntry) public visions;
    mapping(uint256 => Violation) public violations;
    mapping(address => RoleType) public roles;

    event GuardianChanged(address indexed oldGuardian, address indexed newGuardian);
    event RoleAssigned(address indexed account, RoleType role);
    event VisionDeclared(uint256 indexed id, VisionType visionType, address creatorOwner);
    event VisionLocked(uint256 indexed id);
    event ViolationLogged(uint256 indexed id, address violator, VisionType visionType);

    constructor() {
        guardian = msg.sender;
        visionCount = 0;
        violationCount = 0;

        _declareDefaultEternalVision();
    }

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Not authorized");
        _;
    }

    modifier onlyCreator() {
        require(roles[msg.sender] == RoleType.Creator, "Creator only");
        _;
    }

    function _declareDefaultEternalVision() internal {
        _declareVision(VisionType.PrimeVision, "The prime eternal vision of the studio universe", guardian);
        _declareVision(VisionType.CorePhilosophy, "The eternal creative philosophy", guardian);
        _declareVision(VisionType.EternalTheme, "The eternal thematic identity", guardian);
        _declareVision(VisionType.EternalTone, "The eternal narrative tone", guardian);
        _declareVision(VisionType.EternalArtIdentity, "The eternal art identity", guardian);
        _declareVision(VisionType.EternalNarrativeIdentity, "The eternal narrative identity", guardian);
        _declareVision(VisionType.EternalGameplayIdentity, "The eternal gameplay identity", guardian);
        _declareVision(VisionType.EternalWorldIdentity, "The eternal world identity", guardian);
    }

    function _declareVision(
        VisionType visionType,
        string memory description,
        address creatorOwner
    ) internal {
        visionCount++;
        visions[visionCount] = VisionEntry(
            visionCount,
            visionType,
            description,
            creatorOwner,
            false,
            block.timestamp
        );

        emit VisionDeclared(visionCount, visionType, creatorOwner);
    }

    function assignRole(address account, RoleType role) external onlyGuardian {
        roles[account] = role;
        emit RoleAssigned(account, role);
    }

    function declareVision(
        VisionType visionType,
        string calldata description,
        address creatorOwner
    ) external onlyGuardian {
        require(roles[creatorOwner] == RoleType.Creator, "Owner must be creator");
        _declareVision(visionType, description, creatorOwner);
    }

    function lockVision(uint256 id) external onlyCreator {
        VisionEntry storage v = visions[id];
        require(!v.eternalLock, "Already eternal");
        require(v.creatorOwner == msg.sender, "Not owner");

        v.eternalLock = true;
        emit VisionLocked(id);
    }

    function attemptVisionOverride(
        uint256 visionId,
        string calldata details
    ) external {
        RoleType role = roles[msg.sender];
        VisionEntry storage v = visions[visionId];

        if (role != RoleType.Creator) {
            _logViolation(msg.sender, role, v.visionType, details);
        }
    }

    function _logViolation(
        address violator,
        RoleType role,
        VisionType visionType,
        string memory details
    ) internal {
        violationCount++;
        violations[violationCount] = Violation(
            violationCount,
            violator,
            role,
            visionType,
            details,
            block.timestamp
        );

        emit ViolationLogged(violationCount, violator, visionType);
    }

    function changeGuardian(address newGuardian) external onlyGuardian {
        require(newGuardian != address(0), "Invalid guardian");
        emit GuardianChanged(guardian, newGuardian);
        guardian = newGuardian;
    }
}
