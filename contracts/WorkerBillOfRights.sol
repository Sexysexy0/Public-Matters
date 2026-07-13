// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Worker Bill of Rights
/// @notice Constitutional, inalienable rights for all workers; cannot be overridden by any corporate entity, leadership, or future owner
contract WorkerBillOfRights {
    address public guardian;
    uint256 public rightCount;
    uint256 public violationCount;

    enum RoleType {
        Worker,
        Creator,
        Manager,
        Executive,
        Publisher,
        FutureEntity
    }

    enum RightType {
        RightToExistenceSecurity,
        RightToFairProcess,
        RightToTransparentCommunication,
        RightToRespect,
        RightToDignity,
        RightToRecognition,
        RightToServiceHonor,
        RightToNonDiscrimination,
        RightToHumaneExit,
        RightToRetentionReview,
        RightToGenerationalTalentProtection,
        RightToMentalWellbeing,
        RightToSafeEnvironment,
        RightToNonDehumanization,
        RightToVoiceAndDialogue
    }

    enum ViolationType {
        ExistenceThreat,
        UnfairProcess,
        HiddenCommunication,
        Disrespect,
        DignityBreach,
        ContributionErasure,
        ServiceDishonor,
        Discrimination,
        InhumaneExit,
        IgnoredRetention,
        GenerationalTalentHarm,
        MentalHarm,
        UnsafeEnvironment,
        Dehumanization,
        Silencing
    }

    struct RightEntry {
        uint256 id;
        RightType rightType;
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

    event RightDeclared(uint256 indexed id, RightType rightType);
    event RightLocked(uint256 indexed id);
    event ViolationLogged(uint256 indexed id, ViolationType violationType);

    constructor() {
        guardian = msg.sender;
        rightCount = 0;
        violationCount = 0;

        _declareDefaultRights();
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

    function _declareDefaultRights() internal {
        _declareRight(RightType.RightToExistenceSecurity, "Workers cannot be terminated without due process.");
        _declareRight(RightType.RightToFairProcess, "Every employment decision must follow a fair, documented process.");
        _declareRight(RightType.RightToTransparentCommunication, "Communication must be clear, honest, and transparent.");
        _declareRight(RightType.RightToRespect, "Workers must be treated with respect at all times.");
        _declareRight(RightType.RightToDignity, "Dignity is non-negotiable and cannot be violated.");
        _declareRight(RightType.RightToRecognition, "Contributions must be recognized and cannot be erased.");
        _declareRight(RightType.RightToServiceHonor, "Years of service must be honored and respected.");
        _declareRight(RightType.RightToNonDiscrimination, "No discriminatory treatment or termination allowed.");
        _declareRight(RightType.RightToHumaneExit, "Exit must be humane, planned, and compensated fairly.");
        _declareRight(RightType.RightToRetentionReview, "Retention must be considered before termination.");
        _declareRight(RightType.RightToGenerationalTalentProtection, "Generational talents cannot be terminated without extreme justification.");
        _declareRight(RightType.RightToMentalWellbeing, "Mental wellbeing must be protected and considered.");
        _declareRight(RightType.RightToSafeEnvironment, "Workers must have a safe, non-threatening environment.");
        _declareRight(RightType.RightToNonDehumanization, "Workers cannot be treated as numbers or disposable units.");
        _declareRight(RightType.RightToVoiceAndDialogue, "Workers have the right to speak and be heard.");
    }

    function _declareRight(RightType rightType, string memory description) internal {
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
