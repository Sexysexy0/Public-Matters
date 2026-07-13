// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Corporate Limitations
/// @notice Hard limits on corporate power; prevents harmful directives, unethical orders, mass layoffs, and dehumanizing policies
contract CorporateLimitations {
    address public guardian;
    uint256 public limitCount;
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

    enum LimitType {
        NoMassLayoffs,
        NoNumbersBasedTermination,
        NoDehumanizingPolicies,
        NoUnethicalDirectives,
        NoForcedSilence,
        NoContributionErasure,
        NoServiceDisrespect,
        NoGenerationalTalentLoss,
        NoSurpriseTermination,
        NoHarmfulCorporateOrders,
        NoEmotionallyUnsafeProcesses,
        NoOpaqueCommunication,
        NoCorporateOverrideOfEthics,
        NoCorporateOverrideOfHumanRights,
        NoCorporateOverrideOfCreatorGovernance
    }

    enum ViolationType {
        MassLayoffAttempt,
        NumbersBasedTermination,
        DehumanizingPolicy,
        UnethicalDirective,
        ForcedSilence,
        ContributionErasure,
        ServiceDisrespect,
        GenerationalTalentHarm,
        SurpriseTermination,
        HarmfulOrder,
        EmotionalUnsafeProcess,
        OpaqueCommunication,
        EthicsOverrideAttempt,
        HumanRightsOverrideAttempt,
        CreatorGovernanceOverrideAttempt
    }

    struct Limit {
        uint256 id;
        LimitType limitType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct Violation {
        uint256 id;
        address violator;
        ViolationType violationType;
        uint256 limitId;
        string details;
        uint256 timestamp;
    }

    mapping(uint256 => Limit) public limits;
    mapping(uint256 => Violation) public violations;
    mapping(address => RoleType) public roles;

    event LimitDeclared(uint256 indexed id, LimitType limitType);
    event LimitLocked(uint256 indexed id);
    event ViolationLogged(uint256 indexed id, ViolationType violationType);

    constructor() {
        guardian = msg.sender;
        limitCount = 0;
        violationCount = 0;

        _declareDefaultLimits();
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

    function _declareDefaultLimits() internal {
        _declareLimit(LimitType.NoMassLayoffs, "Corporations cannot perform mass layoffs without full review and council approval.");
        _declareLimit(LimitType.NoNumbersBasedTermination, "Termination cannot be based solely on metrics or cost.");
        _declareLimit(LimitType.NoDehumanizingPolicies, "Corporations cannot implement policies that treat workers as numbers.");
        _declareLimit(LimitType.NoUnethicalDirectives, "Unethical corporate directives are forbidden.");
        _declareLimit(LimitType.NoForcedSilence, "Workers cannot be silenced or prevented from speaking.");
        _declareLimit(LimitType.NoContributionErasure, "Corporations cannot erase worker contributions.");
        _declareLimit(LimitType.NoServiceDisrespect, "Years of service cannot be ignored or dishonored.");
        _declareLimit(LimitType.NoGenerationalTalentLoss, "Corporations cannot terminate generational talents without extreme justification.");
        _declareLimit(LimitType.NoSurpriseTermination, "Surprise termination is strictly forbidden.");
        _declareLimit(LimitType.NoHarmfulCorporateOrders, "Corporations cannot issue harmful orders.");
        _declareLimit(LimitType.NoEmotionallyUnsafeProcesses, "Emotionally unsafe processes are prohibited.");
        _declareLimit(LimitType.NoOpaqueCommunication, "Opaque or misleading communication is forbidden.");
        _declareLimit(LimitType.NoCorporateOverrideOfEthics, "Corporate directives cannot override ethics.");
        _declareLimit(LimitType.NoCorporateOverrideOfHumanRights, "Human rights cannot be overridden by corporate interests.");
        _declareLimit(LimitType.NoCorporateOverrideOfCreatorGovernance, "Corporate entities cannot override creator governance systems.");
    }

    function _declareLimit(LimitType limitType, string memory description) internal {
        limitCount++;
        limits[limitCount] = Limit(
            limitCount,
            limitType,
            description,
            false,
            block.timestamp
        );

        emit LimitDeclared(limitCount, limitType);
    }

    function lockLimit(uint256 id) external onlyCreator {
        Limit storage l = limits[id];
        require(!l.immutableEntry, "Already immutable");

        l.immutableEntry = true;
        emit LimitLocked(id);
    }

    function attemptViolation(
        uint256 limitId,
        ViolationType violationType,
        string calldata details
    ) external {
        Limit storage l = limits[limitId];
        RoleType role = roles[msg.sender];

        if (role != RoleType.Creator) {
            _logViolation(msg.sender, violationType, limitId, details);
        }
    }

    function _logViolation(
        address violator,
        ViolationType violationType,
        uint256 limitId,
        string memory details
    ) internal {
        violationCount++;
        violations[violationCount] = Violation(
            violationCount,
            violator,
            violationType,
            limitId,
            details,
            block.timestamp
        );

        emit ViolationLogged(violationCount, violationType);
    }
}
