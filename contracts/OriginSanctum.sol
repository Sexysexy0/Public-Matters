 // SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Origin Sanctum
/// @notice Protects the origin, identity, story, and foundational essence of every human and creator; cannot be overridden by any entity
contract OriginSanctum {
    address public guardian;
    uint256 public sanctumCount;
    uint256 public violationCount;

    enum RoleType {
        Worker,
        Creator,
        Manager,
        Executive,
        Publisher,
        Board,
        FutureEntity
    }

    enum OriginRight {
        RightToOriginIntegrity,
        RightToStoryProtection,
        RightToIdentityOrigin,
        RightToSoulOrigin,
        RightToCulturalOrigin,
        RightToCreativeOrigin,
        RightToExistentialOrigin,
        RightToNonRewrite,
        RightToNonDistortion,
        RightToNonErasure,
        RightToNonOverride,
        RightToNonExtraction,
        RightToNonCorporateClaim,
        RightToOriginTruth,
        RightToOriginContinuity,
        RightToOriginSanctity,
        RightToProtectionFromLeadershipRewrite,
        RightToProtectionFromCorporateRewrite,
        RightToProtectionFromAbusiveNarratives
    }

    enum ViolationType {
        OriginDamage,
        StoryRewrite,
        IdentityOriginHarm,
        SoulOriginHarm,
        CulturalOriginHarm,
        CreativeOriginHarm,
        ExistentialOriginHarm,
        RewriteAttempt,
        DistortionAttempt,
        ErasureAttempt,
        OverrideAttempt,
        ExtractionAttempt,
        CorporateClaimAttempt,
        OriginTruthViolation,
        OriginContinuityBreak,
        OriginSanctityViolation,
        LeadershipRewrite,
        CorporateRewrite,
        AbusiveNarrative
    }

    struct SanctumEntry {
        uint256 id;
        OriginRight rightType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct Violation {
        uint256 id;
        address violator;
        ViolationType violationType;
        uint256 sanctumId;
        string details;
        uint256 timestamp;
    }

    mapping(uint256 => SanctumEntry) public sanctum;
    mapping(uint256 => Violation) public violations;
    mapping(address => RoleType) public roles;

    event SanctumDeclared(uint256 indexed id, OriginRight rightType);
    event SanctumLocked(uint256 indexed id);
    event ViolationLogged(uint256 indexed id, ViolationType violationType);

    constructor() {
        guardian = msg.sender;
        sanctumCount = 0;
        violationCount = 0;

        _declareDefaultOriginRights();
    }

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Not authorized");
        _;
    }

    modifier onlyCreator() {
        require(roles[msg.sender] == RoleType.Creator, "Creator only");
        _;
    }

    function assignRole(address account, RoleType role) external onlyGuardian {
        roles[account] = role;
    }

    function _declareDefaultOriginRights() internal {
        _declareOrigin(OriginRight.RightToOriginIntegrity, "Origin integrity cannot be harmed.");
        _declareOrigin(OriginRight.RightToStoryProtection, "A person's story cannot be rewritten.");
        _declareOrigin(OriginRight.RightToIdentityOrigin, "Identity origin cannot be damaged.");
        _declareOrigin(OriginRight.RightToSoulOrigin, "Soul origin cannot be violated.");
        _declareOrigin(OriginRight.RightToCulturalOrigin, "Cultural origin cannot be erased.");
        _declareOrigin(OriginRight.RightToCreativeOrigin, "Creative origin must be preserved.");
        _declareOrigin(OriginRight.RightToExistentialOrigin, "Existential origin cannot be threatened.");
        _declareOrigin(OriginRight.RightToNonRewrite, "No entity may rewrite human origin.");
        _declareOrigin(OriginRight.RightToNonDistortion, "Origin cannot be distorted.");
        _declareOrigin(OriginRight.RightToNonErasure, "Origin cannot be erased.");
        _declareOrigin(OriginRight.RightToNonOverride, "Origin cannot be overridden.");
        _declareOrigin(OriginRight.RightToNonExtraction, "Origin cannot be extracted or harvested.");
        _declareOrigin(OriginRight.RightToNonCorporateClaim, "Corporations cannot claim ownership over human origin.");
        _declareOrigin(OriginRight.RightToOriginTruth, "Origin truth must be preserved.");
        _declareOrigin(OriginRight.RightToOriginContinuity, "Origin continuity must be protected.");
        _declareOrigin(OriginRight.RightToOriginSanctity, "Origin is sacred and inviolable.");
        _declareOrigin(OriginRight.RightToProtectionFromLeadershipRewrite, "Leadership cannot rewrite human origin.");
        _declareOrigin(OriginRight.RightToProtectionFromCorporateRewrite, "Corporate entities cannot rewrite human origin.");
        _declareOrigin(OriginRight.RightToProtectionFromAbusiveNarratives, "Abusive narratives cannot target human origin.");
    }

    function _declareOrigin(OriginRight rightType, string memory description) internal {
        sanctumCount++;
        sanctum[sanctumCount] = SanctumEntry(
            sanctumCount,
            rightType,
            description,
            false,
            block.timestamp
        );

        emit SanctumDeclared(sanctumCount, rightType);
    }

    function lockSanctum(uint256 id) external onlyCreator {
        SanctumEntry storage s = sanctum[id];
        require(!s.immutableEntry, "Already immutable");

        s.immutableEntry = true;
        emit SanctumLocked(id);
    }

    function attemptViolation(
        uint256 sanctumId,
        ViolationType violationType,
        string calldata details
    ) external {
        SanctumEntry storage s = sanctum[sanctumId];
        RoleType role = roles[msg.sender];

        if (role != RoleType.Creator) {
            _logViolation(msg.sender, violationType, sanctumId, details);
        }
    }

    function _logViolation(
        address violator,
        ViolationType violationType,
        uint256 sanctumId,
        string memory details
    ) internal {
        violationCount++;
        violations[violationCount] = Violation(
            violationCount,
            violator,
            violationType,
            sanctumId,
            details,
            block.timestamp
        );

        emit ViolationLogged(violationCount, violationType);
    }
}
