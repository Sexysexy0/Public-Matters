// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Human Protection Protocol
/// @notice Supreme human safety layer; prevents harm, abuse, dehumanization, unfair treatment, and unsafe corporate behavior
contract HumanProtectionProtocol {
    address public guardian;
    uint256 public ruleCount;
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

    enum ProtectionRule {
        NoHarm,
        NoAbuse,
        NoDehumanization,
        NoUnfairTreatment,
        NoUnsafeEnvironment,
        NoPsychologicalDamage,
        NoEmotionalDamage,
        NoEconomicDamageWithoutReview,
        NoExistentialThreat,
        NoForcedSilence,
        NoRightsViolation,
        NoUnjustTermination,
        NoMassLayoff,
        NoContributionErasure,
        NoServiceDisrespect,
        NoGenerationalTalentLoss,
        NoOpaqueCommunication,
        NoCorporateOverrideOfHumanSafety
    }

    enum ViolationType {
        Harm,
        Abuse,
        Dehumanization,
        UnfairTreatment,
        UnsafeEnvironment,
        PsychologicalDamage,
        EmotionalDamage,
        EconomicDamage,
        ExistentialThreat,
        ForcedSilence,
        RightsViolation,
        UnjustTermination,
        MassLayoffAttempt,
        ContributionErasure,
        ServiceDisrespect,
        GenerationalTalentHarm,
        OpaqueCommunication,
        CorporateOverrideAttempt
    }

    struct Rule {
        uint256 id;
        ProtectionRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct Violation {
        uint256 id;
        address violator;
        ViolationType violationType;
        uint256 ruleId;
        string details;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => Violation) public violations;
    mapping(address => RoleType) public roles;

    event RuleDeclared(uint256 indexed id, ProtectionRule ruleType);
    event RuleLocked(uint256 indexed id);
    event ViolationLogged(uint256 indexed id, ViolationType violationType);

    constructor() {
        guardian = msg.sender;
        ruleCount = 0;
        violationCount = 0;

        _declareDefaultRules();
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

    function _declareDefaultRules() internal {
        _declareRule(ProtectionRule.NoHarm, "No decision may cause harm to any human.");
        _declareRule(ProtectionRule.NoAbuse, "Abusive behavior is strictly forbidden.");
        _declareRule(ProtectionRule.NoDehumanization, "Humans cannot be treated as numbers or disposable units.");
        _declareRule(ProtectionRule.NoUnfairTreatment, "Unfair treatment is prohibited.");
        _declareRule(ProtectionRule.NoUnsafeEnvironment, "Workers must be protected from unsafe environments.");
        _declareRule(ProtectionRule.NoPsychologicalDamage, "Psychological harm is forbidden.");
        _declareRule(ProtectionRule.NoEmotionalDamage, "Emotional harm is forbidden.");
        _declareRule(ProtectionRule.NoEconomicDamageWithoutReview, "Economic harm requires full review and justification.");
        _declareRule(ProtectionRule.NoExistentialThreat, "Workers cannot be threatened with existential loss.");
        _declareRule(ProtectionRule.NoForcedSilence, "Workers cannot be silenced.");
        _declareRule(ProtectionRule.NoRightsViolation, "Human rights cannot be violated.");
        _declareRule(ProtectionRule.NoUnjustTermination, "Unjust termination is forbidden.");
        _declareRule(ProtectionRule.NoMassLayoff, "Mass layoffs are prohibited without full council review.");
        _declareRule(ProtectionRule.NoContributionErasure, "Contributions cannot be erased.");
        _declareRule(ProtectionRule.NoServiceDisrespect, "Years of service must be honored.");
        _declareRule(ProtectionRule.NoGenerationalTalentLoss, "Generational talents cannot be terminated.");
        _declareRule(ProtectionRule.NoOpaqueCommunication, "Opaque communication is forbidden.");
        _declareRule(ProtectionRule.NoCorporateOverrideOfHumanSafety, "Corporate directives cannot override human safety.");
    }

    function _declareRule(ProtectionRule ruleType, string memory description) internal {
        ruleCount++;
        rules[ruleCount] = Rule(
            ruleCount,
            ruleType,
            description,
            false,
            block.timestamp
        );

        emit RuleDeclared(ruleCount, ruleType);
    }

    function lockRule(uint256 id) external onlyCreator {
        Rule storage r = rules[id];
        require(!r.immutableEntry, "Already immutable");

        r.immutableEntry = true;
        emit RuleLocked(id);
    }

    function attemptViolation(
        uint256 ruleId,
        ViolationType violationType,
        string calldata details
    ) external {
        Rule storage r = rules[ruleId];
        RoleType role = roles[msg.sender];

        if (role != RoleType.Creator) {
            _logViolation(msg.sender, violationType, ruleId, details);
        }
    }

    function _logViolation(
        address violator,
        ViolationType violationType,
        uint256 ruleId,
        string memory details
    ) internal {
        violationCount++;
        violations[violationCount] = Violation(
            violationCount,
            violator,
            violationType,
            ruleId,
            details,
            block.timestamp
        );

        emit ViolationLogged(violationCount, violationType);
    }
}
