// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Existential Safety
/// @notice Protects humans from existential harm: loss of livelihood, identity, dignity, stability, or future due to harmful decisions
contract ExistentialSafety {
    address public guardian;
    uint256 public shieldCount;
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

    enum ExistentialShield {
        ShieldFromLivelihoodLoss,
        ShieldFromIdentityDamage,
        ShieldFromDignityCollapse,
        ShieldFromFutureDestruction,
        ShieldFromEconomicCatastrophe,
        ShieldFromForcedLifeChange,
        ShieldFromCorporateExistentialThreats,
        ShieldFromMassLayoffShock,
        ShieldFromSuddenTerminationImpact,
        ShieldFromPsychologicalCollapse,
        ShieldFromEmotionalCollapse,
        ShieldFromSocialDestabilization,
        ShieldFromCulturalErasure,
        ShieldFromGenerationalTalentLoss,
        ShieldFromUnsafeLeadership,
        ShieldFromUnethicalCorporatePower
    }

    enum ViolationType {
        LivelihoodLoss,
        IdentityDamage,
        DignityCollapse,
        FutureDestruction,
        EconomicCatastrophe,
        ForcedLifeChange,
        CorporateExistentialThreat,
        MassLayoffShock,
        SuddenTerminationImpact,
        PsychologicalCollapse,
        EmotionalCollapse,
        SocialDestabilization,
        CulturalErasure,
        GenerationalTalentLoss,
        UnsafeLeadership,
        UnethicalCorporatePower
    }

    struct Shield {
        uint256 id;
        ExistentialShield shieldType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct Violation {
        uint256 id;
        address violator;
        ViolationType violationType;
        uint256 shieldId;
        string details;
        uint256 timestamp;
    }

    mapping(uint256 => Shield) public shields;
    mapping(uint256 => Violation) public violations;
    mapping(address => RoleType) public roles;

    event ShieldDeclared(uint256 indexed id, ExistentialShield shieldType);
    event ShieldLocked(uint256 indexed id);
    event ViolationLogged(uint256 indexed id, ViolationType violationType);

    constructor() {
        guardian = msg.sender;
        shieldCount = 0;
        violationCount = 0;

        _declareDefaultShields();
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

    function _declareDefaultShields() internal {
        _declareShield(ExistentialShield.ShieldFromLivelihoodLoss, "Workers cannot lose livelihood without full protection.");
        _declareShield(ExistentialShield.ShieldFromIdentityDamage, "Identity cannot be harmed by corporate decisions.");
        _declareShield(ExistentialShield.ShieldFromDignityCollapse, "Dignity cannot be collapsed by leadership actions.");
        _declareShield(ExistentialShield.ShieldFromFutureDestruction, "Future stability cannot be destroyed by sudden decisions.");
        _declareShield(ExistentialShield.ShieldFromEconomicCatastrophe, "Economic catastrophe requires full review and compensation.");
        _declareShield(ExistentialShield.ShieldFromForcedLifeChange, "Workers cannot be forced into life‑altering changes.");
        _declareShield(ExistentialShield.ShieldFromCorporateExistentialThreats, "Corporations cannot threaten existential stability.");
        _declareShield(ExistentialShield.ShieldFromMassLayoffShock, "Mass layoff shock is forbidden.");
        _declareShield(ExistentialShield.ShieldFromSuddenTerminationImpact, "Sudden termination impact must be prevented.");
        _declareShield(ExistentialShield.ShieldFromPsychologicalCollapse, "Psychological collapse must be prevented.");
        _declareShield(ExistentialShield.ShieldFromEmotionalCollapse, "Emotional collapse must be prevented.");
        _declareShield(ExistentialShield.ShieldFromSocialDestabilization, "Corporate actions cannot destabilize social life.");
        _declareShield(ExistentialShield.ShieldFromCulturalErasure, "Cultural identity cannot be erased.");
        _declareShield(ExistentialShield.ShieldFromGenerationalTalentLoss, "Generational talents cannot be existentially harmed.");
        _declareShield(ExistentialShield.ShieldFromUnsafeLeadership, "Unsafe leadership is forbidden.");
        _declareShield(ExistentialShield.ShieldFromUnethicalCorporatePower, "Unethical corporate power cannot override human safety.");
    }

    function _declareShield(ExistentialShield shieldType, string memory description) internal {
        shieldCount++;
        shields[shieldCount] = Shield(
            shieldCount,
            shieldType,
            description,
            false,
            block.timestamp
        );

        emit ShieldDeclared(shieldCount, shieldType);
    }

    function lockShield(uint256 id) external onlyCreator {
        Shield storage s = shields[id];
        require(!s.immutableEntry, "Already immutable");

        s.immutableEntry = true;
        emit ShieldLocked(id);
    }

    function attemptViolation(
        uint256 shieldId,
        ViolationType violationType,
        string calldata details
    ) external {
        Shield storage s = shields[shieldId];
        RoleType role = roles[msg.sender];

        if (role != RoleType.Creator) {
            _logViolation(msg.sender, violationType, shieldId, details);
        }
    }

    function _logViolation(
        address violator,
        ViolationType violationType,
        uint256 shieldId,
        string memory details
    ) internal {
        violationCount++;
        violations[violationCount] = Violation(
            violationCount,
            violator,
            violationType,
            shieldId,
            details,
            block.timestamp
        );

        emit ViolationLogged(violationCount, violationType);
    }
}
