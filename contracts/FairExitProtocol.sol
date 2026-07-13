// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Fair Exit Protocol
/// @notice Enforces humane, fair, and transparent exit processes; blocks surprise termination and numbers-based layoffs
contract FairExitProtocol {
    address public guardian;
    uint256 public exitCaseCount;
    uint256 public violationCount;

    enum RoleType {
        Worker,
        Creator,
        Manager,
        Executive,
        Publisher
    }

    enum ExitStatus {
        Pending,
        DialogueRequired,
        TransitionPlanning,
        CompensationReview,
        ClearedForExit,
        Blocked
    }

    enum ViolationType {
        SurpriseTermination,
        NoDialogue,
        NoTransitionPlan,
        NoCompensationReview,
        NumbersBasedExit,
        DiscriminatoryExit
    }

    struct ExitCase {
        uint256 id;
        address worker;
        uint256 yearsOfService;
        string contributions;
        bool generationalTalent;
        ExitStatus status;
        address initiatedBy;
        uint256 timestamp;
    }

    struct Violation {
        uint256 id;
        address violator;
        ViolationType violationType;
        uint256 caseId;
        string details;
        uint256 timestamp;
    }

    mapping(uint256 => ExitCase) public exitCases;
    mapping<uint256 => Violation> public violations;
    mapping(address => RoleType) public roles;

    event ExitCaseFiled(uint256 indexed id, address worker);
    event ExitStatusChanged(uint256 indexed id, ExitStatus status);
    event ViolationLogged(uint256 indexed id, ViolationType violationType);

    constructor() {
        guardian = msg.sender;
        exitCaseCount = 0;
        violationCount = 0;
    }

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Not authorized");
        _;
    }

    modifier onlyCreatorOrManager() {
        require(
            roles[msg.sender] == RoleType.Creator ||
            roles[msg.sender] == RoleType.Manager,
            "Creator or Manager only"
        );
        _;
    }

    // Assign roles
    function assignRole(address account, RoleType role) external onlyGuardian {
        roles[account] = role;
    }

    // File exit case
    function fileExitCase(
        address worker,
        uint256 yearsOfService,
        string calldata contributions,
        bool generationalTalent
    ) external onlyCreatorOrManager {
        exitCaseCount++;
        exitCases[exitCaseCount] = ExitCase(
            exitCaseCount,
            worker,
            yearsOfService,
            contributions,
            generationalTalent,
            ExitStatus.Pending,
            msg.sender,
            block.timestamp
        );

        emit ExitCaseFiled(exitCaseCount, worker);
    }

    // Update exit status
    function updateExitStatus(uint256 caseId, ExitStatus status) external onlyCreatorOrManager {
        ExitCase storage c = exitCases[caseId];
        c.status = status;

        emit ExitStatusChanged(caseId, status);
    }

    // Attempt exit
    function attemptExit(uint256 caseId, string calldata details) external {
        ExitCase storage c = exitCases[caseId];

        // Surprise termination
        if (c.status == ExitStatus.Pending) {
            _logViolation(msg.sender, ViolationType.SurpriseTermination, caseId, details);
        }

        // No dialogue
        if (c.status != ExitStatus.DialogueRequired &&
            c.status != ExitStatus.TransitionPlanning &&
            c.status != ExitStatus.CompensationReview &&
            c.status != ExitStatus.ClearedForExit) {
            _logViolation(msg.sender, ViolationType.NoDialogue, caseId, details);
        }

        // No transition plan
        if (c.status != ExitStatus.TransitionPlanning &&
            c.status != ExitStatus.ClearedForExit) {
            _logViolation(msg.sender, ViolationType.NoTransitionPlan, caseId, details);
        }

        // No compensation review
        if (c.status != ExitStatus.CompensationReview &&
            c.status != ExitStatus.ClearedForExit) {
            _logViolation(msg.sender, ViolationType.NoCompensationReview, caseId, details);
        }

        // Numbers-based exit
        if (bytes(c.contributions).length == 0) {
            _logViolation(msg.sender, ViolationType.NumbersBasedExit, caseId, details);
        }

        // Generational talent protection
        if (c.generationalTalent) {
            _logViolation(msg.sender, ViolationType.DiscriminatoryExit, caseId, details);
        }
    }

    function _logViolation(
        address violator,
        ViolationType violationType,
        uint256 caseId,
        string memory details
    ) internal {
        violationCount++;
        violations[violationCount] = Violation(
            violationCount,
            violator,
            violationType,
            caseId,
            details,
            block.timestamp
        );

        emit ViolationLogged(violationCount, violationType);
    }
}
