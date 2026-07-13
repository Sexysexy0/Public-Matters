// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Risk Context Review Covenant
/// @notice Ensures that risk-taking in innovation, procurement, and governance is evaluated fairly and cannot be misclassified as corruption.
/// @dev Works with InnovationSafetyCovenant, ProcurementClarity, and AntiWeaponization to prevent wrongful prosecution.

contract RiskContextReview {
    address public guardian;
    uint256 public ruleCount;
    uint256 public reviewCount;
    uint256 public councilCount;

    enum RoleType {
        Innovator,
        PublicServant,
        ProcurementOfficer,
        Auditor,
        Council,
        Oversight,
        FutureEntity
    }

    enum RiskRule {
        RiskIsNotCorruption,
        RiskMustBeMeasured,
        RiskMustBeContextualized,
        MarketConditionsRequired,
        UrgencyContextRequired,
        PublicBenefitContextRequired,
        AlternativeAnalysisRequired,
        NoPunishmentForCalculatedRisk,
        NoPunishmentForGoodFaithRisk,
        MandatoryMultiCouncilRiskReview
    }

    enum RiskIssue {
        MisclassifiedRisk,
        IgnoredContext,
        IgnoredMarketConditions,
        IgnoredUrgency,
        IgnoredAlternatives,
        IgnoredPublicBenefit,
        PunishedCalculatedRisk,
        PunishedGoodFaithRisk
    }

    enum ReviewStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        ConfirmedMisclassification
    }

    struct Rule {
        uint256 id;
        RiskRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct RiskReview {
        uint256 id;
        address accuser;
        address accused;
        RiskIssue issueType;
        string details;
        ReviewStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => RiskReview) public reviews;
    mapping(address => RoleType) public roles;
    mapping(address => bool) public councilMember;

    event RuleDeclared(uint256 indexed id, RiskRule ruleType);
    event RuleLocked(uint256 indexed id);
    event ReviewFiled(uint256 indexed id, RiskIssue issueType);
    event ReviewStatusChanged(uint256 indexed id, ReviewStatus status);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        ruleCount = 0;
        reviewCount = 0;
        councilCount = 0;

        _declareDefaultRules();
    }

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Guardian only");
        _;
    }

    modifier onlyCouncil() {
        require(councilMember[msg.sender], "Council only");
        _;
    }

    function assignRole(address account, RoleType role) external onlyGuardian {
        roles[account] = role;
    }

    function addCouncilMember(address member) external onlyGuardian {
        require(!councilMember[member], "Already council");
        councilMember[member] = true;
        councilCount++;
        emit CouncilMemberAdded(member);
    }

    function removeCouncilMember(address member) external onlyGuardian {
        require(councilMember[member], "Not council");
        councilMember[member] = false;
        councilCount--;
        emit CouncilMemberRemoved(member);
    }

    function _declareDefaultRules() internal {
        _declareRule(RiskRule.RiskIsNotCorruption, "Risk-taking cannot be treated as corruption.");
        _declareRule(RiskRule.RiskMustBeMeasured, "Risk must be measured objectively.");
        _declareRule(RiskRule.RiskMustBeContextualized, "Risk must be evaluated in full context.");
        _declareRule(RiskRule.MarketConditionsRequired, "Market conditions must be considered.");
        _declareRule(RiskRule.UrgencyContextRequired, "Urgency context must be evaluated.");
        _declareRule(RiskRule.PublicBenefitContextRequired, "Public benefit must be weighed.");
        _declareRule(RiskRule.AlternativeAnalysisRequired, "Alternatives must be reviewed.");
        _declareRule(RiskRule.NoPunishmentForCalculatedRisk, "Calculated risk cannot be punished.");
        _declareRule(RiskRule.NoPunishmentForGoodFaithRisk, "Good-faith risk cannot be punished.");
        _declareRule(RiskRule.MandatoryMultiCouncilRiskReview, "Risk misclassification requires multi-council review.");
    }

    function _declareRule(RiskRule ruleType, string memory description) internal {
        ruleCount++;
        rules[ruleCount] = Rule(
            ruleCount,
            ruleType,
            description,
            false,
            block.timestamp
        );
        emit RuleDeclared(ruleCount, ruleType);
    }

    function lockRule(uint256 id) external onlyGuardian {
        Rule storage r = rules[id];
        require(!r.immutableEntry, "Already immutable");
        r.immutableEntry = true;
        emit RuleLocked(id);
    }

    function fileRiskReview(
        address accused,
        RiskIssue issueType,
        string calldata details
    ) external {
        reviewCount++;
        reviews[reviewCount] = RiskReview(
            reviewCount,
            msg.sender,
            accused,
            issueType,
            details,
            ReviewStatus.Filed,
            0,
            block.timestamp
        );

        emit ReviewFiled(reviewCount, issueType);
    }

    function beginReview(uint256 reviewId) external onlyCouncil {
        RiskReview storage r = reviews[reviewId];
        require(r.status == ReviewStatus.Filed, "Not filed");
        r.status = ReviewStatus.UnderReview;
        emit ReviewStatusChanged(reviewId, ReviewStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 reviewId) external onlyCouncil {
        RiskReview storage r = reviews[reviewId];
        require(r.status == ReviewStatus.UnderReview, "Not under review");
        r.status = ReviewStatus.MultiCouncilReview;
        emit ReviewStatusChanged(reviewId, ReviewStatus.MultiCouncilReview);
    }

    function approveMisclassification(uint256 reviewId) external onlyCouncil {
        RiskReview storage r = reviews[reviewId];
        require(r.status == ReviewStatus.MultiCouncilReview, "Not in council stage");

        r.approvals++;

        if (r.approvals * 2 > councilCount && councilCount > 0) {
            r.status = ReviewStatus.ConfirmedMisclassification;
            emit ReviewStatusChanged(reviewId, ReviewStatus.ConfirmedMisclassification);
        }
    }

    function rejectReview(uint256 reviewId) external onlyCouncil {
        RiskReview storage r = reviews[reviewId];
        require(
            r.status == ReviewStatus.Filed ||
            r.status == ReviewStatus.UnderReview ||
            r.status == ReviewStatus.MultiCouncilReview,
            "Invalid status"
        );
        r.status = ReviewStatus.Rejected;
        emit ReviewStatusChanged(reviewId, ReviewStatus.Rejected);
    }
}
