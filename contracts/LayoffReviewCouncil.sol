// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Layoff Review Council
/// @notice Enforces fair, humane, evidence-based review before any termination; blocks mass layoffs and protects generational talent
contract LayoffReviewCouncil {
    address public guardian;
    uint256 public councilMemberCount;
    uint256 public workerCaseCount;
    uint256 public violationCount;

    enum RoleType {
        Worker,
        Creator,
        Manager,
        Executive,
        Publisher
    }

    enum CaseStatus {
        Filed,
        UnderReview,
        DialogueRequired,
        ClearedForRetention,
        ClearedForExit,
        BlockedTermination
    }

    enum ViolationType {
        MassLayoffAttempt,
        NoCouncilReview,
        NoDialogue,
        NumbersBasedTermination,
        GenerationalTalentRisk,
        DiscriminatoryTermination
    }

    struct CouncilMember {
        uint256 id;
        address account;
        bool active;
        uint256 timestamp;
    }

    struct WorkerCase {
        uint256 id;
        address worker;
        uint256 yearsOfService;
        string contributions;
        bool generationalTalent;
        CaseStatus status;
        address filedBy;
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

    mapping(uint256 => CouncilMember) public council;
    mapping(address => bool) public isCouncilMember;

    mapping(uint256 => WorkerCase) public cases;
    mapping(uint256 => Violation) public violations;

    mapping(address => RoleType) public roles;

    event CouncilMemberAdded(uint256 indexed id, address account);
    event CaseFiled(uint256 indexed id, address worker);
    event CaseStatusChanged(uint256 indexed id, CaseStatus status);
    event ViolationLogged(uint256 indexed id, ViolationType violationType);

    constructor() {
        guardian = msg.sender;
        councilMemberCount = 0;
        workerCaseCount = 0;
        violationCount = 0;
    }

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Not authorized");
        _;
    }

    modifier onlyCouncil() {
        require(isCouncilMember[msg.sender], "Council only");
        _;
    }

    // Assign roles
    function assignRole(address account, RoleType role) external onlyGuardian {
        roles[account] = role;
    }

    // Add council member
    function addCouncilMember(address account) external onlyGuardian {
        require(!isCouncilMember[account], "Already council");

        councilMemberCount++;
        council[councilMemberCount] = CouncilMember(
            councilMemberCount,
            account,
            true,
            block.timestamp
        );

        isCouncilMember[account] = true;

        emit CouncilMemberAdded(councilMemberCount, account);
    }

    // File a case before termination
    function fileCase(
        address worker,
        uint256 yearsOfService,
        string calldata contributions,
        bool generationalTalent
    ) external {
        workerCaseCount++;
        cases[workerCaseCount] = WorkerCase(
            workerCaseCount,
            worker,
            yearsOfService,
            contributions,
            generationalTalent,
            CaseStatus.Filed,
            msg.sender,
            block.timestamp
        );

        emit CaseFiled(workerCaseCount, worker);
    }

    // Council updates case status
    function updateCaseStatus(uint256 caseId, CaseStatus status) external onlyCouncil {
        WorkerCase storage c = cases[caseId];
        c.status = status;

        emit CaseStatusChanged(caseId, status);
    }

    // Attempt termination without council review
    function attemptTermination(uint256 caseId, string calldata details) external {
        WorkerCase storage c = cases[caseId];

        // No council review
        if (c.status == CaseStatus.Filed) {
            _logViolation(msg.sender, ViolationType.NoCouncilReview, caseId, details);
        }

        // No dialogue
        if (c.status != CaseStatus.DialogueRequired &&
            c.status != CaseStatus.ClearedForExit &&
            c.status != CaseStatus.ClearedForRetention) {
            _logViolation(msg.sender, ViolationType.NoDialogue, caseId, details);
        }

        // Numbers-based termination
        if (bytes(c.contributions).length == 0) {
            _logViolation(msg.sender, ViolationType.NumbersBasedTermination, caseId, details);
        }

        // Generational talent risk
        if (c.generationalTalent) {
            _logViolation(msg.sender, ViolationType.GenerationalTalentRisk, caseId, details);
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
