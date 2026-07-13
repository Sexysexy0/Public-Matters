// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Humanity Root
/// @notice Root-level protection of human identity, dignity, essence, and existential value; cannot be overridden by any entity
contract HumanityRoot {
    address public guardian;
    uint256 public rootCount;
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

    enum RootPrinciple {
        HumanEssenceIsSacred,
        IdentityIsInviolable,
        DignityIsAbsolute,
        HumanityCannotBeReduced,
        ExistenceHasIntrinsicValue,
        PersonhoodCannotBeCompromised,
        EmotionalCoreMustBeProtected,
        PsychologicalCoreMustBeProtected,
        CulturalIdentityMustBePreserved,
        CreativeIdentityMustBePreserved,
        LifeContinuityMustBeEnsured,
        NoEntityMayOverrideHumanity,
        NoEntityMayEraseIdentity,
        NoEntityMayDamageEssence,
        NoEntityMayThreatenExistence,
        NoEntityMayDevalueHumanLife,
        NoEntityMayDehumanize,
        NoEntityMayExploitHumanCore
    }

    enum ViolationType {
        EssenceDamage,
        IdentityErasure,
        DignityViolation,
        HumanityReduction,
        ExistenceDevaluation,
        PersonhoodCompromise,
        EmotionalCoreHarm,
        PsychologicalCoreHarm,
        CulturalIdentityDamage,
        CreativeIdentityDamage,
        LifeContinuityThreat,
        HumanityOverrideAttempt,
        IdentityOverrideAttempt,
        EssenceOverrideAttempt,
        ExistenceThreat,
        HumanLifeDevaluation,
        Dehumanization,
        CoreExploitation
    }

    struct RootEntry {
        uint256 id;
        RootPrinciple principleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct Violation {
        uint256 id;
        address violator;
        ViolationType violationType;
        uint256 rootId;
        string details;
        uint256 timestamp;
    }

    mapping(uint256 => RootEntry) public roots;
    mapping<uint256 => Violation) public violations;
    mapping(address => RoleType) public roles;

    event RootDeclared(uint256 indexed id, RootPrinciple principleType);
    event RootLocked(uint256 indexed id);
    event ViolationLogged(uint256 indexed id, ViolationType violationType);

    constructor() {
        guardian = msg.sender;
        rootCount = 0;
        violationCount = 0;

        _declareDefaultRoots();
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

    function _declareDefaultRoots() internal {
        _declareRoot(RootPrinciple.HumanEssenceIsSacred, "Human essence is sacred and cannot be violated.");
        _declareRoot(RootPrinciple.IdentityIsInviolable, "Human identity cannot be harmed or erased.");
        _declareRoot(RootPrinciple.DignityIsAbsolute, "Dignity is absolute and cannot be compromised.");
        _declareRoot(RootPrinciple.HumanityCannotBeReduced, "Humanity cannot be reduced to metrics or cost.");
        _declareRoot(RootPrinciple.ExistenceHasIntrinsicValue, "Human existence has intrinsic value beyond utility.");
        _declareRoot(RootPrinciple.PersonhoodCannotBeCompromised, "Personhood cannot be compromised by corporate actions.");
        _declareRoot(RootPrinciple.EmotionalCoreMustBeProtected, "Emotional core must be protected at all times.");
        _declareRoot(RootPrinciple.PsychologicalCoreMustBeProtected, "Psychological core must be protected.");
        _declareRoot(RootPrinciple.CulturalIdentityMustBePreserved, "Cultural identity cannot be erased.");
        _declareRoot(RootPrinciple.CreativeIdentityMustBePreserved, "Creative identity must be preserved.");
        _declareRoot(RootPrinciple.LifeContinuityMustBeEnsured, "Life continuity must be protected from disruption.");
        _declareRoot(RootPrinciple.NoEntityMayOverrideHumanity, "No entity may override human humanity.");
        _declareRoot(RootPrinciple.NoEntityMayEraseIdentity, "Identity cannot be erased by any directive.");
        _declareRoot(RootPrinciple.NoEntityMayDamageEssence, "Human essence cannot be damaged.");
        _declareRoot(RootPrinciple.NoEntityMayThreatenExistence, "Existential threats are forbidden.");
        _declareRoot(RootPrinciple.NoEntityMayDevalueHumanLife, "Human life cannot be devalued.");
        _declareRoot(RootPrinciple.NoEntityMayDehumanize, "Dehumanization is forbidden at the root level.");
        _declareRoot(RootPrinciple.NoEntityMayExploitHumanCore, "Human core cannot be exploited.");
    }

    function _declareRoot(RootPrinciple principleType, string memory description) internal {
        rootCount++;
        roots[rootCount] = RootEntry(
            rootCount,
            principleType,
            description,
            false,
            block.timestamp
        );

        emit RootDeclared(rootCount, principleType);
    }

    function lockRoot(uint256 id) external onlyCreator {
        RootEntry storage r = roots[id];
        require(!r.immutableEntry, "Already immutable");

        r.immutableEntry = true;
        emit RootLocked(id);
    }

    function attemptViolation(
        uint256 rootId,
        ViolationType violationType,
        string calldata details
    ) external {
        RootEntry storage r = roots[rootId];
        RoleType role = roles[msg.sender];

        if (role != RoleType.Creator) {
            _logViolation(msg.sender, violationType, rootId, details);
        }
    }

    function _logViolation(
        address violator,
        ViolationType violationType,
        uint256 rootId,
        string memory details
    ) internal {
        violationCount++;
        violations[violationCount] = Violation(
            violationCount,
            violator,
            violationType,
            rootId,
            details,
            block.timestamp
        );

        emit ViolationLogged(violationCount, violationType);
    }
}
