// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Supreme Human Rights
/// @notice Absolute, non-negotiable human rights; cannot be overridden by any corporate, managerial, executive, or future entity
contract SupremeHumanRights {
    address public guardian;
    uint256 public rightCount;
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

    enum SupremeRight {
        RightToExistenceSecurity,
        RightToDignity,
        RightToHumanValue,
        RightToSafety,
        RightToFairTreatment,
        RightToNonDehumanization,
        RightToVoice,
        RightToDialogue,
        RightToTransparency,
        RightToMentalWellbeing,
        RightToEmotionalSafety,
        RightToEconomicSecurity,
        RightToNonDiscrimination,
        RightToContributionRecognition,
        RightToServiceHonor,
        RightToHumaneExit,
        RightToRetentionReview,
        RightToGenerationalTalentProtection,
        RightToProtectionFromCorporateAbuse,
        RightToProtectionFromUnethicalDirectives,
        RightToProtectionFromExistentialThreats,
        RightToProtectionFromMassLayoffs,
        RightToProtectionFromOpaqueCommunication,
        RightToProtectionFromForcedSilence,
        RightToProtectionFromPsychologicalHarm,
        RightToProtectionFromEmotionalHarm,
        RightToProtectionFromDehumanizingPolicies
    }

    enum ViolationType {
        ExistenceThreat,
        DignityBreach,
        HumanValueViolation,
        SafetyViolation,
        UnfairTreatment,
        Dehumanization,
        Silencing,
        DialogueDenial,
        OpaqueCommunication,
        MentalHarm,
        EmotionalHarm,
        EconomicHarm,
        Discrimination,
        ContributionErasure,
        ServiceDishonor,
        InhumaneExit,
        IgnoredRetention,
        GenerationalTalentHarm,
        CorporateAbuse,
        UnethicalDirective,
        ExistentialThreat,
        MassLayoffAttempt,
        ForcedSilence,
        PsychologicalDamage,
        EmotionalDamage,
        DehumanizingPolicy
    }

    struct RightEntry {
        uint256 id;
        SupremeRight rightType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct Violation {
        uint256 id;
        address violator;
        ViolationType violationType;
        uint256 rightId;
        string details;
        uint256 timestamp;
    }

    mapping(uint256 => RightEntry) public rights;
    mapping(uint256 => Violation) public violations;
    mapping(address => RoleType) public roles;

    event RightDeclared(uint256 indexed id, SupremeRight rightType);
    event RightLocked(uint256 indexed id);
    event ViolationLogged(uint256 indexed id, ViolationType violationType);

    constructor() {
        guardian = msg.sender;
        rightCount = 0;
        violationCount = 0;

        _declareDefaultSupremeRights();
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

    function _declareDefaultSupremeRights() internal {
        _declareRight(SupremeRight.RightToExistenceSecurity, "Humans cannot be threatened with existential loss.");
        _declareRight(SupremeRight.RightToDignity, "Human dignity is absolute and cannot be violated.");
        _declareRight(SupremeRight.RightToHumanValue, "Human value cannot be reduced to metrics or cost.");
        _declareRight(SupremeRight.RightToSafety, "Humans must be protected from unsafe environments.");
        _declareRight(SupremeRight.RightToFairTreatment, "Fair treatment is mandatory.");
        _declareRight(SupremeRight.RightToNonDehumanization, "Dehumanization is forbidden.");
        _declareRight(SupremeRight.RightToVoice, "Humans must be allowed to speak and be heard.");
        _declareRight(SupremeRight.RightToDialogue, "Dialogue is required before any major decision.");
        _declareRight(SupremeRight.RightToTransparency, "Communication must be honest and transparent.");
        _declareRight(SupremeRight.RightToMentalWellbeing, "Mental wellbeing must be protected.");
        _declareRight(SupremeRight.RightToEmotionalSafety, "Emotional safety must be ensured.");
        _declareRight(SupremeRight.RightToEconomicSecurity, "Economic harm requires full review and justification.");
        _declareRight(SupremeRight.RightToNonDiscrimination, "Discrimination is forbidden.");
        _declareRight(SupremeRight.RightToContributionRecognition, "Contributions cannot be erased.");
        _declareRight(SupremeRight.RightToServiceHonor, "Years of service must be honored.");
        _declareRight(SupremeRight.RightToHumaneExit, "Exit must be humane and compensated fairly.");
        _declareRight(SupremeRight.RightToRetentionReview, "Retention must be considered before termination.");
        _declareRight(SupremeRight.RightToGenerationalTalentProtection, "Generational talents must be protected.");
        _declareRight(SupremeRight.RightToProtectionFromCorporateAbuse, "Corporate abuse is forbidden.");
        _declareRight(SupremeRight.RightToProtectionFromUnethicalDirectives, "Unethical directives cannot be followed.");
        _declareRight(SupremeRight.RightToProtectionFromExistentialThreats, "Existential threats are forbidden.");
        _declareRight(SupremeRight.RightToProtectionFromMassLayoffs, "Mass layoffs are prohibited.");
        _declareRight(SupremeRight.RightToProtectionFromOpaqueCommunication, "Opaque communication is forbidden.");
        _declareRight(SupremeRight.RightToProtectionFromForcedSilence, "Forced silence is forbidden.");
        _declareRight(SupremeRight.RightToProtectionFromPsychologicalHarm, "Psychological harm is forbidden.");
        _declareRight(SupremeRight.RightToProtectionFromEmotionalHarm, "Emotional harm is forbidden.");
        _declareRight(SupremeRight.RightToProtectionFromDehumanizingPolicies, "Dehumanizing policies are forbidden.");
    }

    function _declareRight(SupremeRight rightType, string memory description) internal {
        rightCount++;
        rights[rightCount] = RightEntry(
            rightCount,
            rightType,
            description,
            false,
            block.timestamp
        );

        emit RightDeclared(rightCount, rightType);
    }

    function lockRight(uint256 id) external onlyCreator {
        RightEntry storage r = rights[id];
        require(!r.immutableEntry, "Already immutable");

        r.immutableEntry = true;
        emit RightLocked(id);
    }

    function attemptViolation(
        uint256 rightId,
        ViolationType violationType,
        string calldata details
    ) external {
        RightEntry storage r = rights[rightId];
        RoleType role = roles[msg.sender];

        if (role != RoleType.Creator) {
            _logViolation(msg.sender, violationType, rightId, details);
        }
    }

    function _logViolation(
        address violator,
        ViolationType violationType,
        uint256 rightId,
        string memory details
    ) internal {
        violationCount++;
        violations[violationCount] = Violation(
            violationCount,
            violator,
            violationType,
            rightId,
            details,
            block.timestamp
        );

        emit ViolationLogged(violationCount, violationType);
    }
}
