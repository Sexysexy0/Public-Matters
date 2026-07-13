// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Moral Governance
/// @notice Supreme moral constitution combining humanity, fairness, dignity, ethics, and duty of care; cannot be overridden by any entity
contract MoralGovernance {
    address public guardian;
    uint256 public principleCount;
    uint256 public violationCount;

    enum RoleType {
        Worker,
        Creator,
        Manager,
        Executive,
        Publisher,
        FutureEntity
    }

    enum PrincipleType {
        HumanDignityIsAbsolute,
        PeopleAreNotNumbers,
        FairnessIsMandatory,
        DialogueIsRequired,
        LeadershipMustProtect,
        NoHarmPrinciple,
        CompassionOverMetrics,
        ServiceMustBeHonored,
        ContributionsMustBeRecognized,
        GenerationalTalentIsSacred,
        HumaneExitIsRequired,
        TransparencyIsLaw,
        EmotionalSafetyIsMandatory,
        NoDehumanizationEver,
        EthicsOverrideCorporateDirectives
    }

    enum ViolationType {
        DignityBreach,
        Dehumanization,
        UnfairProcess,
        DialogueDenial,
        HarmfulLeadership,
        MetricsOverHumanity,
        ServiceDishonor,
        ContributionErasure,
        GenerationalTalentHarm,
        InhumaneExit,
        HiddenCommunication,
        EmotionalHarm,
        UnsafeEnvironment,
        CorporateOverrideAttempt
    }

    struct Principle {
        uint256 id;
        PrincipleType principleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct Violation {
        uint256 id;
        address violator;
        ViolationType violationType;
        uint256 principleId;
        string details;
        uint256 timestamp;
    }

    mapping(uint256 => Principle) public principles;
    mapping(uint256 => Violation) public violations;
    mapping(address => RoleType) public roles;

    event PrincipleDeclared(uint256 indexed id, PrincipleType principleType);
    event PrincipleLocked(uint256 indexed id);
    event ViolationLogged(uint256 indexed id, ViolationType violationType);

    constructor() {
        guardian = msg.sender;
        principleCount = 0;
        violationCount = 0;

        _declareDefaultPrinciples();
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

    function _declareDefaultPrinciples() internal {
        _declarePrinciple(PrincipleType.HumanDignityIsAbsolute, "Human dignity cannot be violated under any circumstance.");
        _declarePrinciple(PrincipleType.PeopleAreNotNumbers, "Humans cannot be reduced to metrics or cost.");
        _declarePrinciple(PrincipleType.FairnessIsMandatory, "All decisions must follow fairness and due process.");
        _declarePrinciple(PrincipleType.DialogueIsRequired, "Dialogue must occur before any major decision.");
        _declarePrinciple(PrincipleType.LeadershipMustProtect, "Leadership must protect workers from harm.");
        _declarePrinciple(PrincipleType.NoHarmPrinciple, "No decision may cause harm to workers.");
        _declarePrinciple(PrincipleType.CompassionOverMetrics, "Compassion must override metrics in human decisions.");
        _declarePrinciple(PrincipleType.ServiceMustBeHonored, "Years of service must be honored and respected.");
        _declarePrinciple(PrincipleType.ContributionsMustBeRecognized, "Contributions cannot be erased or ignored.");
        _declarePrinciple(PrincipleType.GenerationalTalentIsSacred, "Generational talents must be protected.");
        _declarePrinciple(PrincipleType.HumaneExitIsRequired, "Exit must be humane, planned, and compensated fairly.");
        _declarePrinciple(PrincipleType.TransparencyIsLaw, "Communication must be honest and transparent.");
        _declarePrinciple(PrincipleType.EmotionalSafetyIsMandatory, "Workers must be emotionally safe in all processes.");
        _declarePrinciple(PrincipleType.NoDehumanizationEver, "Dehumanization is strictly forbidden.");
        _declarePrinciple(PrincipleType.EthicsOverrideCorporateDirectives, "Ethics must override any harmful corporate directive.");
    }

    function _declarePrinciple(PrincipleType principleType, string memory description) internal {
        principleCount++;
        principles[principleCount] = Principle(
            principleCount,
            principleType,
            description,
            false,
            block.timestamp
        );

        emit PrincipleDeclared(principleCount, principleType);
    }

    function lockPrinciple(uint256 id) external onlyCreator {
        Principle storage p = principles[id];
        require(!p.immutableEntry, "Already immutable");

        p.immutableEntry = true;
        emit PrincipleLocked(id);
    }

    function attemptViolation(
        uint256 principleId,
        ViolationType violationType,
        string calldata details
    ) external {
        Principle storage p = principles[principleId];
        RoleType role = roles[msg.sender];

        if (role != RoleType.Creator) {
            _logViolation(msg.sender, violationType, principleId, details);
        }
    }

    function _logViolation(
        address violator,
        ViolationType violationType,
        uint256 principleId,
        string memory details
    ) internal {
        violationCount++;
        violations[violationCount] = Violation(
            violationCount,
            violator,
            violationType,
            principleId,
            details,
            block.timestamp
        );

        emit ViolationLogged(violationCount, violationType);
    }
}
