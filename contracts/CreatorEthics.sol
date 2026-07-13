// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Creator Ethics
/// @notice Ethical operating system for creators and leaders; defines non-negotiable ethical behavior and moral obligations
contract CreatorEthics {
    address public guardian;
    uint256 public ethicCount;
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

    enum EthicType {
        ActWithIntegrity,
        LeadWithCompassion,
        ProtectHumanity,
        HonorService,
        RecognizeContribution,
        EnsureFairProcess,
        PreventHarm,
        CommunicateHonestly,
        MaintainTransparency,
        UpholdDignity,
        RespectVoice,
        AvoidDehumanization,
        PrioritizeWellbeing,
        RejectUnethicalDirectives,
        DefendGenerationalTalent,
        PreserveCreativeCulture,
        UpholdMoralGovernance
    }

    enum ViolationType {
        IntegrityBreach,
        CruelLeadership,
        HumanityViolation,
        ServiceDishonor,
        ContributionErasure,
        UnfairProcess,
        HarmfulDecision,
        DishonestCommunication,
        OpaqueBehavior,
        DignityBreach,
        Silencing,
        Dehumanization,
        WellbeingNeglect,
        UnethicalDirectiveCompliance,
        GenerationalTalentHarm,
        CultureDamage,
        MoralGovernanceOverride
    }

    struct Ethic {
        uint256 id;
        EthicType ethicType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct Violation {
        uint256 id;
        address violator;
        ViolationType violationType;
        uint256 ethicId;
        string details;
        uint256 timestamp;
    }

    mapping(uint256 => Ethic) public ethics;
    mapping<uint256 => Violation) public violations;
    mapping(address => RoleType) public roles;

    event EthicDeclared(uint256 indexed id, EthicType ethicType);
    event EthicLocked(uint256 indexed id);
    event ViolationLogged(uint256 indexed id, ViolationType violationType);

    constructor() {
        guardian = msg.sender;
        ethicCount = 0;
        violationCount = 0;

        _declareDefaultEthics();
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

    function _declareDefaultEthics() internal {
        _declareEthic(EthicType.ActWithIntegrity, "Creators must act with integrity at all times.");
        _declareEthic(EthicType.LeadWithCompassion, "Leadership must be compassionate and humane.");
        _declareEthic(EthicType.ProtectHumanity, "Creators must protect human dignity and wellbeing.");
        _declareEthic(EthicType.HonorService, "Years of service must be honored.");
        _declareEthic(EthicType.RecognizeContribution, "Contributions must be recognized and respected.");
        _declareEthic(EthicType.EnsureFairProcess, "Creators must ensure fair and documented processes.");
        _declareEthic(EthicType.PreventHarm, "Creators must avoid decisions that cause harm.");
        _declareEthic(EthicType.CommunicateHonestly, "Communication must be honest and transparent.");
        _declareEthic(EthicType.MaintainTransparency, "Creators must maintain transparency in decisions.");
        _declareEthic(EthicType.UpholdDignity, "Creators must uphold human dignity.");
        _declareEthic(EthicType.RespectVoice, "Workers must be allowed to speak and be heard.");
        _declareEthic(EthicType.AvoidDehumanization, "Creators must never treat workers as numbers.");
        _declareEthic(EthicType.PrioritizeWellbeing, "Creators must prioritize mental and emotional wellbeing.");
        _declareEthic(EthicType.RejectUnethicalDirectives, "Creators must reject unethical corporate directives.");
        _declareEthic(EthicType.DefendGenerationalTalent, "Creators must defend generational talents.");
        _declareEthic(EthicType.PreserveCreativeCulture, "Creators must preserve studio culture and identity.");
        _declareEthic(EthicType.UpholdMoralGovernance, "Creators must uphold the supreme moral governance system.");
    }

    function _declareEthic(EthicType ethicType, string memory description) internal {
        ethicCount++;
        ethics[ethicCount] = Ethic(
            ethicCount,
            ethicType,
            description,
            false,
            block.timestamp
        );

        emit EthicDeclared(ethicCount, ethicType);
    }

    function lockEthic(uint256 id) external onlyCreator {
        Ethic storage e = ethics[id];
        require(!e.immutableEntry, "Already immutable");

        e.immutableEntry = true;
        emit EthicLocked(id);
    }

    function attemptViolation(
        uint256 ethicId,
        ViolationType violationType,
        string calldata details
    ) external {
        Ethic storage e = ethics[ethicId];
        RoleType role = roles[msg.sender];

        if (role != RoleType.Creator) {
            _logViolation(msg.sender, violationType, ethicId, details);
        }
    }

    function _logViolation(
        address violator,
        ViolationType violationType,
        uintuint ethicId,
        string memory details
    ) internal {
        violationCount++;
        violations[violationCount] = Violation(
            violationCount,
            violator,
            violationType,
            ethicId,
            details,
            block.timestamp
        );

        emit ViolationLogged(violationCount, violationType);
    }
}
