// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Life Continuity
/// @notice Protects continuity of livelihood, identity, future, stability, and purpose; prevents existential disruption by any entity
contract LifeContinuity {
    address public guardian;
    uint256 public continuityCount;
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

    enum ContinuityRight {
        RightToLivelihoodContinuity,
        RightToIdentityContinuity,
        RightToFutureContinuity,
        RightToStabilityContinuity,
        RightToPurposeContinuity,
        RightToCreativeTrajectoryContinuity,
        RightToEconomicContinuity,
        RightToEmotionalContinuity,
        RightToPsychologicalContinuity,
        RightToSocialContinuity,
        RightToCulturalContinuity,
        RightToExistentialContinuity,
        RightToNonDisruption,
        RightToNonDestabilization,
        RightToNonDerailment,
        RightToProtectionFromCorporateShock,
        RightToProtectionFromSuddenLifeChange,
        RightToProtectionFromLeadershipInstability,
        RightToProtectionFromUnethicalCorporatePower
    }

    enum ViolationType {
        LivelihoodBreak,
        IdentityBreak,
        FutureBreak,
        StabilityBreak,
        PurposeBreak,
        CreativeTrajectoryBreak,
        EconomicBreak,
        EmotionalBreak,
        PsychologicalBreak,
        SocialBreak,
        CulturalBreak,
        ExistentialBreak,
        DisruptionAttempt,
        DestabilizationAttempt,
        DerailmentAttempt,
        CorporateShock,
        ForcedLifeChange,
        LeadershipInstability,
        UnethicalCorporatePower
    }

    struct ContinuityEntry {
        uint256 id;
        ContinuityRight rightType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct Violation {
        uint256 id;
        address violator;
        ViolationType violationType;
        uint256 continuityId;
        string details;
        uint256 timestamp;
    }

    mapping(uint256 => ContinuityEntry) public continuity;
    mapping(uint256 => Violation) public violations;
    mapping(address => RoleType) public roles;

    event ContinuityDeclared(uint256 indexed id, ContinuityRight rightType);
    event ContinuityLocked(uint256 indexed id);
    event ViolationLogged(uint256 indexed id, ViolationType violationType);

    constructor() {
        guardian = msg.sender;
        continuityCount = 0;
        violationCount = 0;

        _declareDefaultContinuityRights();
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

    function _declareDefaultContinuityRights() internal {
        _declareContinuity(ContinuityRight.RightToLivelihoodContinuity, "Livelihood cannot be disrupted by corporate decisions.");
        _declareContinuity(ContinuityRight.RightToIdentityContinuity, "Identity continuity must be preserved.");
        _declareContinuity(ContinuityRight.RightToFutureContinuity, "Future trajectory cannot be derailed.");
        _declareContinuity(ContinuityRight.RightToStabilityContinuity, "Life stability must be protected.");
        _declareContinuity(ContinuityRight.RightToPurposeContinuity, "Purpose cannot be disrupted.");
        _declareContinuity(ContinuityRight.RightToCreativeTrajectoryContinuity, "Creative trajectory cannot be interfered with.");
        _declareContinuity(ContinuityRight.RightToEconomicContinuity, "Economic continuity must be ensured.");
        _declareContinuity(ContinuityRight.RightToEmotionalContinuity, "Emotional continuity must be protected.");
        _declareContinuity(ContinuityRight.RightToPsychologicalContinuity, "Psychological continuity must be preserved.");
        _declareContinuity(ContinuityRight.RightToSocialContinuity, "Social stability cannot be destabilized.");
        _declareContinuity(ContinuityRight.RightToCulturalContinuity, "Cultural identity continuity must be preserved.");
        _declareContinuity(ContinuityRight.RightToExistentialContinuity, "Existential continuity cannot be threatened.");
        _declareContinuity(ContinuityRight.RightToNonDisruption, "Life cannot be disrupted by harmful directives.");
        _declareContinuity(ContinuityRight.RightToNonDestabilization, "Destabilization attempts are forbidden.");
        _declareContinuity(ContinuityRight.RightToNonDerailment, "Life trajectory cannot be derailed.");
        _declareContinuity(ContinuityRight.RightToProtectionFromCorporateShock, "Corporate shock events are forbidden.");
        _declareContinuity(ContinuityRight.RightToProtectionFromSuddenLifeChange, "Sudden life changes cannot be forced.");
        _declareContinuity(ContinuityRight.RightToProtectionFromLeadershipInstability, "Leadership instability cannot harm life continuity.");
        _declareContinuity(ContinuityRight.RightToProtectionFromUnethicalCorporatePower, "Unethical corporate power cannot override continuity.");
    }

    function _declareContinuity(ContinuityRight rightType, string memory description) internal {
        continuityCount++;
        continuity[continuityCount] = ContinuityEntry(
            continuityCount,
            rightType,
            description,
            false,
            block.timestamp
        );

        emit ContinuityDeclared(continuityCount, rightType);
    }

    function lockContinuity(uint256 id) external onlyCreator {
        ContinuityEntry storage c = continuity[id];
        require(!c.immutableEntry, "Already immutable");

        c.immutableEntry = true;
        emit ContinuityLocked(id);
    }

    function attemptViolation(
        uint256 continuityId,
        ViolationType violationType,
        string calldata details
    ) external {
        ContinuityEntry storage c = continuity[continuityId];
        RoleType role = roles[msg.sender];

        if (role != RoleType.Creator) {
            _logViolation(msg.sender, violationType, continuityId, details);
        }
    }

    function _logViolation(
        address violator,
        ViolationType violationType,
        uint256 continuityId,
        string memory details
    ) internal {
        violationCount++;
        violations[violationCount] = Violation(
            violationCount,
            violator,
            violationType,
            continuityId,
            details,
            block.timestamp
        );

        emit ViolationLogged(violationCount, violationType);
    }
}
