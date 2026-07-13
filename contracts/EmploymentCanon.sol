// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Employment Canon
/// @notice Immutable worker rights; cannot be overridden by management, executives, publishers, or future corporate owners
contract EmploymentCanon {
    address public guardian;
    uint256 public canonCount;
    uint256 public violationCount;

    enum RoleType {
        Worker,
        Creator,
        Manager,
        Executive,
        Publisher,
        FutureEntity
    }

    enum CanonRight {
        RightToFairReview,
        RightToDialogue,
        RightToDignity,
        RightToContributionRecognition,
        RightToServiceRespect,
        RightToNonDiscriminatoryTreatment,
        RightToHumaneExit,
        RightToRetentionConsideration,
        RightToGenerationalTalentProtection
    }

    enum ViolationType {
        DeniedReview,
        DeniedDialogue,
        DignityViolation,
        ContributionErasure,
        ServiceDisrespect,
        DiscriminatoryAction,
        InhumaneExit,
        IgnoredRetention,
        GenerationalTalentHarm
    }

    struct CanonEntry {
        uint256 id;
        CanonRight rightType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct Violation {
        uint256 id;
        address violator;
        ViolationType violationType;
        uint256 canonId;
        string details;
        uint256 timestamp;
    }

    mapping(uint256 => CanonEntry) public canon;
    mapping(uint256 => Violation) public violations;
    mapping(address => RoleType) public roles;

    event CanonDeclared(uint256 indexed id, CanonRight rightType);
    event CanonLocked(uint256 indexed id);
    event ViolationLogged(uint256 indexed id, ViolationType violationType);

    constructor() {
        guardian = msg.sender;
        canonCount = 0;
        violationCount = 0;

        _declareDefaultCanon();
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

    function _declareDefaultCanon() internal {
        _declareCanon(CanonRight.RightToFairReview, "Every worker has the right to a fair review before any termination.");
        _declareCanon(CanonRight.RightToDialogue, "Every worker must be spoken to before any employment decision.");
        _declareCanon(CanonRight.RightToDignity, "Every worker must be treated with dignity at all times.");
        _declareCanon(CanonRight.RightToContributionRecognition, "Contributions must be recognized and cannot be erased.");
        _declareCanon(CanonRight.RightToServiceRespect, "Years of service must be respected and cannot be ignored.");
        _declareCanon(CanonRight.RightToNonDiscriminatoryTreatment, "No discriminatory termination or treatment allowed.");
        _declareCanon(CanonRight.RightToHumaneExit, "Exit must be humane, planned, and compensated fairly.");
        _declareCanon(CanonRight.RightToRetentionConsideration, "Retention must be considered before termination.");
        _declareCanon(CanonRight.RightToGenerationalTalentProtection, "Generational talents cannot be terminated without extreme justification.");
    }

    function _declareCanon(CanonRight rightType, string memory description) internal {
        canonCount++;
        canon[canonCount] = CanonEntry(
            canonCount,
            rightType,
            description,
            false,
            block.timestamp
        );

        emit CanonDeclared(canonCount, rightType);
    }

    function lockCanon(uint256 id) external onlyCreator {
        CanonEntry storage c = canon[id];
        require(!c.immutableEntry, "Already immutable");

        c.immutableEntry = true;
        emit CanonLocked(id);
    }

    function attemptViolation(
        uint256 canonId,
        ViolationType violationType,
        string calldata details
    ) external {
        CanonEntry storage c = canon[canonId];
        RoleType role = roles[msg.sender];

        if (role != RoleType.Creator) {
            _logViolation(msg.sender, violationType, canonId, details);
        }
    }

    function _logViolation(
        address violator,
        ViolationType violationType,
        uint256 canonId,
        string memory details
    ) internal {
        violationCount++;
        violations[violationCount] = Violation(
            violationCount,
            violator,
            violationType,
            canonId,
            details,
            block.timestamp
        );

        emit ViolationLogged(violationCount, violationType);
    }
}
