// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Talent Retention
/// @notice Protects generational talents and long-term contributors from unfair termination; enforces retention-first policy
contract TalentRetention {
    address public guardian;
    uint256 public talentCount;
    uint256 public reviewCount;
    uint256 public violationCount;

    enum RoleType {
        Worker,
        Creator,
        Manager,
        Executive,
        Publisher
    }

    enum TalentStatus {
        Active,
        UnderRetentionReview,
        RetentionRecommended,
        RetainMandatory,
        ExitAllowed
    }

    enum ViolationType {
        AttemptedTerminationOfGenerationalTalent,
        NoRetentionReview,
        NoDialogue,
        NumbersBasedTermination,
        DiscriminatoryTermination
    }

    struct Talent {
        uint256 id;
        address account;
        uint256 yearsOfService;
        string contributions;
        bool generationalTalent;
        TalentStatus status;
        uint256 timestamp;
    }

    struct RetentionReview {
        uint256 id;
        uint256 talentId;
        string notes;
        address reviewer;
        bool dialogueCompleted;
        bool retentionRecommended;
        uint256 timestamp;
    }

    struct Violation {
        uint256 id;
        address violator;
        ViolationType violationType;
        uint256 talentId;
        string details;
        uint256 timestamp;
    }

    mapping(uint256 => Talent) public talents;
    mapping(address => uint256) public talentByAddress;

    mapping(uint256 => RetentionReview) public reviews;
    mapping(uint256 => Violation) public violations;

    mapping(address => RoleType) public roles;

    event TalentAdded(uint256 indexed id, address account);
    event RetentionReviewCreated(uint256 indexed id, uint256 talentId);
    event RetentionReviewUpdated(uint256 indexed id);
    event ViolationLogged(uint256 indexed id, ViolationType violationType);

    constructor() {
        guardian = msg.sender;
        talentCount = 0;
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

    // Add talent
    function addTalent(
        address account,
        uint256 yearsOfService,
        string calldata contributions,
        bool generationalTalent
    ) external onlyGuardian {
        require(talentByAddress[account] == 0, "Already added");

        talentCount++;
        talents[talentCount] = Talent(
            talentCount,
            account,
            yearsOfService,
            contributions,
            generationalTalent,
            TalentStatus.Active,
            block.timestamp
        );

        talentByAddress[account] = talentCount;

        emit TalentAdded(talentCount, account);
    }

    // Create retention review
    function createRetentionReview(uint256 talentId, string calldata notes) external onlyCreatorOrManager {
        reviewCount++;
        reviews[reviewCount] = RetentionReview(
            reviewCount,
            talentId,
            notes,
            msg.sender,
            false,
            false,
            block.timestamp
        );

        talents[talentId].status = TalentStatus.UnderRetentionReview;

        emit RetentionReviewCreated(reviewCount, talentId);
    }

    // Update retention review
    function updateRetentionReview(
        uint256 reviewId,
        bool dialogueCompleted,
        bool retentionRecommended
    ) external onlyCreatorOrManager {
        RetentionReview storage r = reviews[reviewId];
        r.dialogueCompleted = dialogueCompleted;
        r.retentionRecommended = retentionRecommended;

        Talent storage t = talents[r.talentId];

        if (retentionRecommended) {
            t.status = TalentStatus.RetainMandatory;
        } else if (dialogueCompleted) {
            t.status = TalentStatus.ExitAllowed;
        }

        emit RetentionReviewUpdated(reviewId);
    }

    // Attempt termination
    function attemptTermination(uint256 talentId, string calldata details) external {
        Talent storage t = talents[talentId];

        // Generational talent protection
        if (t.generationalTalent) {
            _logViolation(msg.sender, ViolationType.AttemptedTerminationOfGenerationalTalent, talentId, details);
        }

        // No retention review
        if (t.status == TalentStatus.Active) {
            _logViolation(msg.sender, ViolationType.NoRetentionReview, talentId, details);
        }

        // No dialogue
        bool dialogueDone = false;
        for (uint256 i = 1; i <= reviewCount; i++) {
            if (reviews[i].talentId == talentId && reviews[i].dialogueCompleted) {
                dialogueDone = true;
                break;
            }
        }
        if (!dialogueDone) {
            _logViolation(msg.sender, ViolationType.NoDialogue, talentId, details);
        }

        // Numbers-based termination
        if (bytes(t.contributions).length == 0) {
            _logViolation(msg.sender, ViolationType.NumbersBasedTermination, talentId, details);
        }
    }

    function _logViolation(
        address violator,
        ViolationType violationType,
        uint256 talentId,
        string memory details
    ) internal {
        violationCount++;
        violations[violationCount] = Violation(
            violationCount,
            violator,
            violationType,
            talentId,
            details,
            block.timestamp
        );

        emit ViolationLogged(violationCount, violationType);
    }
}
