// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Internal Feedback Loop Covenant
/// @notice Establishes a protected internal system where team members can safely report issues, imbalances, or leadership risks without fear.
/// @dev Prevents external scandals by ensuring internal criticism is safe, constructive, and protected.

contract InternalFeedbackLoop {
    address public guardian;
    uint256 public ruleCount;
    uint256 public reportCount;
    uint256 public councilCount;

    enum RoleType {
        TeamMember,
        Leader,
        Founder,
        Auditor,
        Council,
        Oversight,
        FutureEntity
    }

    enum FeedbackRule {
        NoRetaliation,
        NoPunishmentForCriticism,
        AnonymousFeedbackAllowed,
        MandatoryRootCauseAnalysis,
        MandatoryLeadershipReview,
        MandatoryTransparencyToCouncil,
        CriticismIsDiagnosticData,
        FeedbackMustBeProtected,
        IssuesMustBeAcknowledged,
        ResolutionMustBeTracked
    }

    enum ReportType {
        LeadershipIssue,
        SystemFlaw,
        CulturalImbalance,
        RiskyDecision,
        PanicBehavior,
        SuppressionAttempt,
        TransparencyFailure,
        TeamConcern
    }

    enum ReportStatus {
        Filed,
        UnderReview,
        CouncilReview,
        Resolved,
        Rejected
    }

    struct Rule {
        uint256 id;
        FeedbackRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct Report {
        uint256 id;
        address reporter;
        address subject;
        ReportType reportType;
        string details;
        ReportStatus status;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => Report) public reports;
    mapping(address => RoleType) public roles;
    mapping(address => bool) public councilMember;

    event RuleDeclared(uint256 indexed id, FeedbackRule ruleType);
    event RuleLocked(uint256 indexed id);
    event ReportFiled(uint256 indexed id, ReportType reportType);
    event ReportStatusChanged(uint256 indexed id, ReportStatus status);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        ruleCount = 0;
        reportCount = 0;
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
        _declareRule(FeedbackRule.NoRetaliation, "No retaliation for internal criticism.");
        _declareRule(FeedbackRule.NoPunishmentForCriticism, "Criticism cannot be punished.");
        _declareRule(FeedbackRule.AnonymousFeedbackAllowed, "Anonymous feedback is allowed.");
        _declareRule(FeedbackRule.MandatoryRootCauseAnalysis, "Root cause analysis is mandatory.");
        _declareRule(FeedbackRule.MandatoryLeadershipReview, "Leadership must review all reports.");
        _declareRule(FeedbackRule.MandatoryTransparencyToCouncil, "Council must see all feedback.");
        _declareRule(FeedbackRule.CriticismIsDiagnosticData, "Criticism is diagnostic data.");
        _declareRule(FeedbackRule.FeedbackMustBeProtected, "Feedback must be protected.");
        _declareRule(FeedbackRule.IssuesMustBeAcknowledged, "Issues must be acknowledged.");
        _declareRule(FeedbackRule.ResolutionMustBeTracked, "Resolution must be tracked.");
    }

    function _declareRule(FeedbackRule ruleType, string memory description) internal {
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

    function fileReport(
        address subject,
        ReportType reportType,
        string calldata details
    ) external {
        reportCount++;
        reports[reportCount] = Report(
            reportCount,
            msg.sender,
            subject,
            reportType,
            details,
            ReportStatus.Filed,
            block.timestamp
        );

        emit ReportFiled(reportCount, reportType);
    }

    function beginReview(uint256 reportId) external onlyCouncil {
        Report storage r = reports[reportId];
        require(r.status == ReportStatus.Filed, "Not filed");
        r.status = ReportStatus.UnderReview;
        emit ReportStatusChanged(reportId, ReportStatus.UnderReview);
    }

    function escalateToCouncil(uint256 reportId) external onlyCouncil {
        Report storage r = reports[reportId];
        require(r.status == ReportStatus.UnderReview, "Not under review");
        r.status = ReportStatus.CouncilReview;
        emit ReportStatusChanged(reportId, ReportStatus.CouncilReview);
    }

    function resolveReport(uint256 reportId) external onlyCouncil {
        Report storage r = reports[reportId];
        require(
            r.status == ReportStatus.UnderReview ||
            r.status == ReportStatus.CouncilReview,
            "Invalid status"
        );
        r.status = ReportStatus.Resolved;
        emit ReportStatusChanged(reportId, ReportStatus.Resolved);
    }

    function rejectReport(uint256 reportId) external onlyCouncil {
        Report storage r = reports[reportId];
        require(
            r.status == ReportStatus.Filed ||
            r.status == ReportStatus.UnderReview ||
            r.status == ReportStatus.CouncilReview,
            "Invalid status"
        );
        r.status = ReportStatus.Rejected;
        emit ReportStatusChanged(reportId, ReportStatus.Rejected);
    }
}
