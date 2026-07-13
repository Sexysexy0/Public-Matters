// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Creator Sanctity
/// @notice Protects creators from exploitation, override, erasure, abuse, and harmful corporate power; establishes creator sovereignty
contract CreatorSanctity {
    address public guardian;
    uint256 public sanctityCount;
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

    enum SanctityRight {
        RightToCreativeSovereignty,
        RightToVisionProtection,
        RightToIdentityIntegrity,
        RightToNonOverride,
        RightToNonErasure,
        RightToRespect,
        RightToSafeLeadership,
        RightToFairTreatment,
        RightToNonExploitation,
        RightToNonCoercion,
        RightToNonManipulation,
        RightToNonCorporateDomination,
        RightToCreativeFreedom,
        RightToRecognition,
        RightToServiceHonor,
        RightToExistentialSafety,
        RightToProtectionFromUnethicalDirectives,
        RightToProtectionFromAbusiveLeadership,
        RightToProtectionFromCorporatePowerAbuse
    }

    enum ViolationType {
        CreativeOverride,
        VisionDamage,
        IdentityViolation,
        Erasure,
        Disrespect,
        UnsafeLeadership,
        UnfairTreatment,
        Exploitation,
        Coercion,
        Manipulation,
        CorporateDomination,
        FreedomViolation,
        RecognitionErasure,
        ServiceDishonor,
        ExistentialThreat,
        UnethicalDirective,
        AbusiveLeadership,
        CorporatePowerAbuse
    }

    struct SanctityEntry {
        uint256 id;
        SanctityRight rightType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct Violation {
        uint256 id;
        address violator;
        ViolationType violationType;
        uint256 sanctityId;
        string details;
        uint256 timestamp;
    }

    mapping(uint256 => SanctityEntry) public sanctity;
    mapping(uint256 => Violation) public violations;
    mapping(address => RoleType) public roles;

    event SanctityDeclared(uint256 indexed id, SanctityRight rightType);
    event SanctityLocked(uint256 indexed id);
    event ViolationLogged(uint256 indexed id, ViolationType violationType);

    constructor() {
        guardian = msg.sender;
        sanctityCount = 0;
        violationCount = 0;

        _declareDefaultSanctityRights();
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

    function _declareDefaultSanctityRights() internal {
        _declareSanctity(SanctityRight.RightToCreativeSovereignty, "Creators hold sovereign authority over creative direction.");
        _declareSanctity(SanctityRight.RightToVisionProtection, "Creator vision cannot be distorted or overridden.");
        _declareSanctity(SanctityRight.RightToIdentityIntegrity, "Creator identity cannot be harmed or erased.");
        _declareSanctity(SanctityRight.RightToNonOverride, "No entity may override creator decisions without consent.");
        _declareSanctity(SanctityRight.RightToNonErasure, "Creator contributions cannot be erased.");
        _declareSanctity(SanctityRight.RightToRespect, "Creators must be treated with respect at all times.");
        _declareSanctity(SanctityRight.RightToSafeLeadership, "Creators must be protected from unsafe leadership.");
        _declareSanctity(SanctityRight.RightToFairTreatment, "Creators must receive fair treatment.");
        _declareSanctity(SanctityRight.RightToNonExploitation, "Creators cannot be exploited.");
        _declareSanctity(SanctityRight.RightToNonCoercion, "Creators cannot be coerced.");
        _declareSanctity(SanctityRight.RightToNonManipulation, "Creators cannot be manipulated.");
        _declareSanctity(SanctityRight.RightToNonCorporateDomination, "Corporate entities cannot dominate creators.");
        _declareSanctity(SanctityRight.RightToCreativeFreedom, "Creators must have freedom to create.");
        _declareSanctity(SanctityRight.RightToRecognition, "Creator contributions must be recognized.");
        _declareSanctity(SanctityRight.RightToServiceHonor, "Years of creative service must be honored.");
        _declareSanctity(SanctityRight.RightToExistentialSafety, "Creators must be protected from existential harm.");
        _declareSanctity(SanctityRight.RightToProtectionFromUnethicalDirectives, "Creators cannot be forced to follow unethical directives.");
        _declareSanctity(SanctityRight.RightToProtectionFromAbusiveLeadership, "Creators must be protected from abusive leadership.");
        _declareSanctity(SanctityRight.RightToProtectionFromCorporatePowerAbuse, "Corporate power cannot override creator sanctity.");
    }

    function _declareSanctity(SanctityRight rightType, string memory description) internal {
        sanctityCount++;
        sanctity[sanctityCount] = SanctityEntry(
            sanctityCount,
            rightType,
            description,
            false,
            block.timestamp
        );

        emit SanctityDeclared(sanctityCount, rightType);
    }

    function lockSanctity(uint256 id) external onlyCreator {
        SanctityEntry storage s = sanctity[id];
        require(!s.immutableEntry, "Already immutable");

        s.immutableEntry = true;
        emit SanctityLocked(id);
    }

    function attemptViolation(
        uint256 sanctityId,
        ViolationType violationType,
        string calldata details
    ) external {
        SanctityEntry storage s = sanctity[sanctityId];
        RoleType role = roles[msg.sender];

        if (role != RoleType.Creator) {
            _logViolation(msg.sender, violationType, sanctityId, details);
        }
    }

    function _logViolation(
        address violator,
        ViolationType violationType,
        uint256 sanctityId,
        string memory details
    ) internal {
        violationCount++;
        violations[violationCount] = Violation(
            violationCount,
            violator,
            violationType,
            sanctityId,
            details,
            block.timestamp
        );

        emit ViolationLogged(violationCount, violationType);
    }
}
