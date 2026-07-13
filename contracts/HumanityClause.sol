// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Humanity Clause
/// @notice Encodes dignity, humane treatment, and moral obligations toward workers; cannot be overridden by any corporate entity
contract HumanityClause {
    address public guardian;
    uint256 public clauseCount;
    uint256 public violationCount;

    enum RoleType {
        Worker,
        Creator,
        Manager,
        Executive,
        Publisher,
        FutureEntity
    }

    enum HumanityRight {
        RightToDignity,
        RightToRespectfulCommunication,
        RightToNonHumiliation,
        RightToNonDehumanization,
        RightToFairTreatment,
        RightToCompassionateLeadership,
        RightToSafeDialogue,
        RightToEmotionalConsideration,
        RightToHumanValueBeyondMetrics
    }

    enum ViolationType {
        Humiliation,
        Dehumanization,
        DisrespectfulCommunication,
        CruelLeadership,
        EmotionallyUnsafeProcess,
        MetricsOnlyJudgment,
        InhumaneTermination,
        DignityBreach
    }

    struct Clause {
        uint256 id;
        HumanityRight rightType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct Violation {
        uint256 id;
        address violator;
        ViolationType violationType;
        uint256 clauseId;
        string details;
        uint256 timestamp;
    }

    mapping(uint256 => Clause) public clauses;
    mapping(uint256 => Violation> public violations;
    mapping(address => RoleType) public roles;

    event ClauseDeclared(uint256 indexed id, HumanityRight rightType);
    event ClauseLocked(uint256 indexed id);
    event ViolationLogged(uint256 indexed id, ViolationType violationType);

    constructor() {
        guardian = msg.sender;
        clauseCount = 0;
        violationCount = 0;

        _declareDefaultHumanityRights();
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

    function _declareDefaultHumanityRights() internal {
        _declareClause(HumanityRight.RightToDignity, "Every worker must be treated with dignity at all times.");
        _declareClause(HumanityRight.RightToRespectfulCommunication, "Communication must always be respectful and humane.");
        _declareClause(HumanityRight.RightToNonHumiliation, "No worker may be humiliated or shamed.");
        _declareClause(HumanityRight.RightToNonDehumanization, "Workers cannot be treated as numbers or disposable units.");
        _declareClause(HumanityRight.RightToFairTreatment, "Fairness must be upheld in all decisions.");
        _declareClause(HumanityRight.RightToCompassionateLeadership, "Leadership must act with compassion and empathy.");
        _declareClause(HumanityRight.RightToSafeDialogue, "Dialogue must be safe, calm, and non-threatening.");
        _declareClause(HumanityRight.RightToEmotionalConsideration, "Emotional impact must be considered in decisions.");
        _declareClause(HumanityRight.RightToHumanValueBeyondMetrics, "Human value cannot be reduced to metrics or cost.");
    }

    function _declareClause(HumanityRight rightType, string memory description) internal {
        clauseCount++;
        clauses[clauseCount] = Clause(
            clauseCount,
            rightType,
            description,
            false,
            block.timestamp
        );

        emit ClauseDeclared(clauseCount, rightType);
    }

    function lockClause(uint256 id) external onlyCreator {
        Clause storage c = clauses[id];
        require(!c.immutableEntry, "Already immutable");

        c.immutableEntry = true;
        emit ClauseLocked(id);
    }

    function attemptViolation(
        uint256 clauseId,
        ViolationType violationType,
        string calldata details
    ) external {
        Clause storage c = clauses[clauseId];
        RoleType role = roles[msg.sender];

        if (role != RoleType.Creator) {
            _logViolation(msg.sender, violationType, clauseId, details);
        }
    }

    function _logViolation(
        address violator,
        ViolationType violationType,
        uint256 clauseId,
        string memory details
    ) internal {
        violationCount++;
        violations[violationCount] = Violation(
            violationCount,
            violator,
            violationType,
            clauseId,
            details,
            block.timestamp
        );

        emit ViolationLogged(violationCount, violationType);
    }
}
