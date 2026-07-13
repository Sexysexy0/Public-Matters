// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Humanity Prime
/// @notice Final, supreme, untouchable layer of human protection; defines the prime essence of humanity that no entity may override
contract HumanityPrime {
    address public guardian;
    uint256 public primeCount;
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

    enum PrimeEssence {
        PrimeHumanity,
        PrimeIdentity,
        PrimeDignity,
        PrimeExistence,
        PrimeEssenceIntegrity,
        PrimeEmotionalCore,
        PrimePsychologicalCore,
        PrimeCulturalCore,
        PrimeCreativeCore,
        PrimeLifeContinuity,
        PrimeSoulIntegrity,
        PrimeHumanValue,
        PrimeNonReduction,
        PrimeNonErasure,
        PrimeNonOverride,
        PrimeNonThreat,
        PrimeNonExploitation,
        PrimeNonDehumanization,
        PrimeIntrinsicWorth,
        PrimeSacredness
    }

    enum ViolationType {
        HumanityDamage,
        IdentityDamage,
        DignityDamage,
        ExistenceDamage,
        EssenceDamage,
        EmotionalCoreDamage,
        PsychologicalCoreDamage,
        CulturalCoreDamage,
        CreativeCoreDamage,
        LifeContinuityDamage,
        SoulIntegrityDamage,
        HumanValueDamage,
        ReductionAttempt,
        ErasureAttempt,
        OverrideAttempt,
        ThreatAttempt,
        ExploitationAttempt,
        DehumanizationAttempt,
        IntrinsicWorthViolation,
        SacrednessViolation
    }

    struct PrimeEntry {
        uint256 id;
        PrimeEssence essenceType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct Violation {
        uint256 id;
        address violator;
        ViolationType violationType;
        uint256 primeId;
        string details;
        uint256 timestamp;
    }

    mapping(uint256 => PrimeEntry) public primes;
    mapping(uint256 => Violation) public violations;
    mapping(address => RoleType) public roles;

    event PrimeDeclared(uint256 indexed id, PrimeEssence essenceType);
    event PrimeLocked(uint256 indexed id);
    event ViolationLogged(uint256 indexed id, ViolationType violationType);

    constructor() {
        guardian = msg.sender;
        primeCount = 0;
        violationCount = 0;

        _declarePrimeEssence();
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

    function _declarePrimeEssence() internal {
        _declarePrime(PrimeEssence.PrimeHumanity, "Humanity at its prime cannot be harmed.");
        _declarePrime(PrimeEssence.PrimeIdentity, "Prime identity cannot be erased or damaged.");
        _declarePrime(PrimeEssence.PrimeDignity, "Prime dignity is absolute and untouchable.");
        _declarePrime(PrimeEssence.PrimeExistence, "Prime existence cannot be threatened.");
        _declarePrime(PrimeEssence.PrimeEssenceIntegrity, "Prime essence must remain intact.");
        _declarePrime(PrimeEssence.PrimeEmotionalCore, "Prime emotional core cannot be harmed.");
        _declarePrime(PrimeEssence.PrimePsychologicalCore, "Prime psychological core cannot be harmed.");
        _declarePrime(PrimeEssence.PrimeCulturalCore, "Prime cultural core cannot be erased.");
        _declarePrime(PrimeEssence.PrimeCreativeCore, "Prime creative core must remain free.");
        _declarePrime(PrimeEssence.PrimeLifeContinuity, "Prime life continuity cannot be disrupted.");
        _declarePrime(PrimeEssence.PrimeSoulIntegrity, "Prime soul integrity cannot be violated.");
        _declarePrime(PrimeEssence.PrimeHumanValue, "Prime human value cannot be reduced.");
        _declarePrime(PrimeEssence.PrimeNonReduction, "Prime humanity cannot be reduced to metrics.");
        _declarePrime(PrimeEssence.PrimeNonErasure, "Prime identity cannot be erased.");
        _declarePrime(PrimeEssence.PrimeNonOverride, "Prime essence cannot be overridden.");
        _declarePrime(PrimeEssence.PrimeNonThreat, "Prime existence cannot be threatened.");
        _declarePrime(PrimeEssence.PrimeNonExploitation, "Prime humanity cannot be exploited.");
        _declarePrime(PrimeEssence.PrimeNonDehumanization, "Prime humanity cannot be dehumanized.");
        _declarePrime(PrimeEssence.PrimeIntrinsicWorth, "Prime intrinsic worth is eternal.");
        _declarePrime(PrimeEssence.PrimeSacredness, "Prime sacredness of humanity is inviolable.");
    }

    function _declarePrime(PrimeEssence essenceType, string memory description) internal {
        primeCount++;
        primes[primeCount] = PrimeEntry(
            primeCount,
            essenceType,
            description,
            false,
            block.timestamp
        );

        emit PrimeDeclared(primeCount, essenceType);
    }

    function lockPrime(uint256 id) external onlyCreator {
        PrimeEntry storage p = primes[id];
        require(!p.immutableEntry, "Already immutable");

        p.immutableEntry = true;
        emit PrimeLocked(id);
    }

    function attemptViolation(
        uint256 primeId,
        ViolationType violationType,
        string calldata details
    ) external {
        PrimeEntry storage p = primes[primeId];
        RoleType role = roles[msg.sender];

        if (role != RoleType.Creator) {
            _logViolation(msg.sender, violationType, primeId, details);
        }
    }

    function _logViolation(
        address violator,
        ViolationType violationType,
        uint256 primeId,
        string memory details
    ) internal {
        violationCount++;
        violations[violationCount] = Violation(
            violationCount,
            violator,
            violationType,
            primeId,
            details,
            block.timestamp
        );

        emit ViolationLogged(violationCount, violationType);
    }
}
