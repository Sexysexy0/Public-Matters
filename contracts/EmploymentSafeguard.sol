// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Employment Safeguard
/// @notice Protects workers from unfair termination, mass layoffs, and numbers-based firing; enforces fair review and dialogue
contract EmploymentSafeguard {
    address public guardian;
    uint256 public workerCount;
    uint256 public reviewCount;
    uint256 public violationCount;

    enum RoleType {
        Worker,
        Creator,
        Manager,
        Executive,
        Publisher
    }

    enum ReviewStatus {
        Pending,
        InDialogue,
        Completed,
        Cleared,
        RetainRecommended,
        TerminationRecommended
    }

    enum ViolationType {
        MassLayoffAttempt,
        NumbersBasedTermination,
        NoReviewTermination,
        NoDialogueTermination,
        TalentLossRisk,
        DiscriminatoryTermination
    }

    struct Worker {
        uint256 id;
        address account;
        uint256 yearsOfService;
        string contributionSummary;
        bool generationalTalent;
        bool active;
        uint256 timestamp;
    }

    struct Review {
        uint256 id;
        uint256 workerId;
        ReviewStatus status;
        string notes;
        address reviewer;
        uint256 timestamp;
    }

    struct Violation {
        uint256 id;
        address violator;
        ViolationType violationType;
        uint256 workerId;
        string details;
        uint256 timestamp;
    }

    mapping(uint256 => Worker) public workers;
    mapping(address => uint256) public workerByAddress;
    mapping(uint256 => Review) public reviews;
    mapping(uint256 => Violation) public violations;
    mapping(address => RoleType) public roles;

    event WorkerAdded(uint256 indexed id, address account);
    event ReviewCreated(uint256 indexed id, uint256 workerId);
    event ReviewUpdated(uint256 indexed id, ReviewStatus status);
    event ViolationLogged(uint256 indexed id, ViolationType violationType);

    constructor() {
        guardian = msg.sender;
        workerCount = 0;
        reviewCount = 0;
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

    // Add worker
    function addWorker(
        address account,
        uint256 yearsOfService,
        string calldata contributionSummary,
        bool generationalTalent
    ) external onlyGuardian {
        require(workerByAddress[account] == 0, "Already added");

        workerCount++;
        workers[workerCount] = Worker(
            workerCount,
            account,
            yearsOfService,
            contributionSummary,
            generationalTalent,
            true,
            block.timestamp
        );

        workerByAddress[account] = workerCount;

        emit WorkerAdded(workerCount, account);
    }

    // Create review before any termination
    function createReview(uint256 workerId, string calldata notes) external onlyCreatorOrManager {
        reviewCount++;
        reviews[reviewCount] = Review(
            reviewCount,
            workerId,
            ReviewStatus.Pending,
            notes,
            msg.sender,
            block.timestamp
        );

        emit ReviewCreated(reviewCount, workerId);
    }

    // Update review status
    function updateReview(uint256 reviewId, ReviewStatus status) external onlyCreatorOrManager {
        Review storage r = reviews[reviewId];
        r.status = status;

        emit ReviewUpdated(reviewId, status);
    }

    // Attempt termination without review = violation
    function attemptTermination(uint256 workerId, string calldata details) external {
        Worker storage w = workers[workerId];
        RoleType role = roles[msg.sender];

        // If no review exists
        bool hasReview = false;
        for (uint256 i = 1; i <= reviewCount; i++) {
            if (reviews[i].workerId == workerId) {
                hasReview = true;
                break;
            }
        }

        if (!hasReview) {
            _logViolation(msg.sender, ViolationType.NoReviewTermination, workerId, details);
        }

        // Numbers-based termination
        if (bytes(w.contributionSummary).length == 0) {
            _logViolation(msg.sender, ViolationType.NumbersBasedTermination, workerId, details);
        }

        // Generational talent risk
        if (w.generationalTalent) {
            _logViolation(msg.sender, ViolationType.TalentLossRisk, workerId, details);
        }
    }

    function _logViolation(
        address violator,
        ViolationType violationType,
        uint256 workerId,
        string memory details
    ) internal {
        violationCount++;
        violations[violationCount] = Violation(
            violationCount,
            violator,
            violationType,
            workerId,
            details,
            block.timestamp
        );

        emit ViolationLogged(violationCount, violationType);
    }
}
