// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Creator Soul
/// @notice Metaphysical protection of creator essence, spirit, identity, fire, and existential creative core; cannot be overridden by any entity
contract CreatorSoul {
    address public guardian;
    uint256 public soulCount;
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

    enum SoulRight {
        RightToEssenceIntegrity,
        RightToCreativeFire,
        RightToVisionSoul,
        RightToIdentitySoul,
        RightToSpiritProtection,
        RightToPurposeSanctity,
        RightToNonExtraction,
        RightToNonManipulation,
        RightToNonDistortion,
        RightToNonOverride,
        RightToNonErasure,
        RightToCreativeTruth,
        RightToExistentialSoulSafety,
        RightToEmotionalSoulSafety,
        RightToPsychologicalSoulSafety,
        RightToCulturalSoulSafety,
        RightToCreativeSoulFreedom,
        RightToProtectionFromCorporateSoulDamage,
        RightToProtectionFromAbusiveLeadership,
        RightToProtectionFromUnethicalDirectives
    }

    enum ViolationType {
        EssenceDamage,
        FireExtinguish,
        VisionSoulHarm,
        IdentitySoulHarm,
        SpiritDamage,
        PurposeViolation,
        ExtractionAttempt,
        ManipulationAttempt,
        DistortionAttempt,
        OverrideAttempt,
        ErasureAttempt,
        TruthViolation,
        ExistentialSoulThreat,
        EmotionalSoulHarm,
        PsychologicalSoulHarm,
        CulturalSoulHarm,
        CreativeSoulRestriction,
        CorporateSoulDamage,
        AbusiveLeadership,
        UnethicalDirective
    }

    struct SoulEntry {
        uint256 id;
        SoulRight rightType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct Violation {
        uint256 id;
        address violator;
        ViolationType violationType;
        uint256 soulId;
        string details;
        uint256 timestamp;
    }

    mapping(uint256 => SoulEntry> public souls;
    mapping<uint256 => Violation> public violations;
    mapping(address => RoleType> public roles;

    event SoulDeclared(uint256 indexed id, SoulRight rightType);
    event SoulLocked(uint256 indexed id);
    event ViolationLogged(uint256 indexed id, ViolationType violationType);

    constructor() {
        guardian = msg.sender;
        soulCount = 0;
        violationCount = 0;

        _declareDefaultSoulRights();
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

    function _declareDefaultSoulRights() internal {
        _declareSoul(SoulRight.RightToEssenceIntegrity, "Creator essence cannot be harmed.");
        _declareSoul(SoulRight.RightToCreativeFire, "Creative fire cannot be extinguished.");
        _declareSoul(SoulRight.RightToVisionSoul, "Vision soul cannot be distorted.");
        _declareSoul(SoulRight.RightToIdentitySoul, "Identity soul cannot be harmed.");
        _declareSoul(SoulRight.RightToSpiritProtection, "Creator spirit must be protected.");
        _declareSoul(SoulRight.RightToPurposeSanctity, "Purpose is sacred and cannot be violated.");
        _declareSoul(SoulRight.RightToNonExtraction, "Creator soul cannot be extracted or harvested.");
        _declareSoul(SoulRight.RightToNonManipulation, "Creator soul cannot be manipulated.");
        _declareSoul(SoulRight.RightToNonDistortion, "Creator soul cannot be distorted.");
        _declareSoul(SoulRight.RightToNonOverride, "No entity may override creator soul.");
        _declareSoul(SoulRight.RightToNonErasure, "Creator soul cannot be erased.");
        _declareSoul(SoulRight.RightToCreativeTruth, "Creator truth must be preserved.");
        _declareSoul(SoulRight.RightToExistentialSoulSafety, "Existential soul safety must be ensured.");
        _declareSoul(SoulRight.RightToEmotionalSoulSafety, "Emotional soul safety must be protected.");
        _declareSoul(SoulRight.RightToPsychologicalSoulSafety, "Psychological soul safety must be protected.");
        _declareSoul(SoulRight.RightToCulturalSoulSafety, "Cultural soul cannot be harmed.");
        _declareSoul(SoulRight.RightToCreativeSoulFreedom, "Creative soul must remain free.");
        _declareSoul(SoulRight.RightToProtectionFromCorporateSoulDamage, "Corporate entities cannot damage creator soul.");
        _declareSoul(SoulRight.RightToProtectionFromAbusiveLeadership, "Abusive leadership cannot harm creator soul.");
        _declareSoul(SoulRight.RightToProtectionFromUnethicalDirectives, "Unethical directives cannot target creator soul.");
    }

    function _declareSoul(SoulRight rightType, string memory description) internal {
        soulCount++;
        souls[soulCount] = SoulEntry(
            soulCount,
            rightType,
            description,
            false,
            block.timestamp
        );

        emit SoulDeclared(soulCount, rightType);
    }

    function lockSoul(uint256 id) external onlyCreator {
        SoulEntry storage s = souls[id];
        require(!s.immutableEntry, "Already immutable");

        s.immutableEntry = true;
        emit SoulLocked(id);
    }

    function attemptViolation(
        uint256 soulId,
        ViolationType violationType,
        string calldata details
    ) external {
        SoulEntry storage s = souls[soulId];
        RoleType role = roles[msg.sender];

        if (role != RoleType.Creator) {
            _logViolation(msg.sender, violationType, soulId, details);
        }
    }

    function _logViolation(
        address violator,
        ViolationType violationType,
        uint256 soulId,
        string memory details
    ) internal {
        violationCount++;
        violations[violationCount] = Violation(
            violationCount,
            violator,
            violationType,
            soulId,
            details,
            block.timestamp
        );

        emit ViolationLogged(violationCount, violationType);
    }
}
