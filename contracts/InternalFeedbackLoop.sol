// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Internal Feedback Loop Covenant
/// @notice Establishes a safe, transparent, and structured feedback mechanism inside organizations.
/// @dev Prevents retaliation, ensures feedback is treated as diagnostic data, and requires multi-council review for serious issues.

contract InternalFeedbackLoop {
    address public guardian;
    uint256 public channelCount;
    uint256 public feedbackCount;
    uint256 public councilCount;

    enum RoleType {
        Employee,
        Innovator,
        PublicServant,
        Founder,
        Council,
        Oversight,
        FutureEntity
    }

    enum FeedbackChannel {
        AnonymousSubmission,
        DirectCouncilSubmission,
        TeamReview,
        PublicTransparencyBoard,
        CrisisFlag
    }

    enum FeedbackType {
        SystemImbalance,
        GovernanceGap,
        LeadershipIssue,
        RetaliationRisk,
        TransparencyFailure,
        PanicDecision,
        SuppressionAttempt,
        CulturalDrift
    }

    enum FeedbackStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Resolved,
        Escalated,
        Rejected
    }

    struct Channel {
        uint256 id;
        FeedbackChannel channelType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct Feedback {
        uint256 id;
        address submitter;
        FeedbackType feedbackType;
        string details;
        FeedbackStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Channel) public channels;
    mapping(uint256 => Feedback) public feedbacks;
    mapping(address => RoleType) public roles;
    mapping(address => bool) public councilMember;

    event ChannelDeclared(uint256 indexed id, FeedbackChannel channelType);
    event ChannelLocked(uint256 indexed id);
    event FeedbackFiled(uint256 indexed id, FeedbackType feedbackType);
    event FeedbackStatusChanged(uint256 indexed id, FeedbackStatus status);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        channelCount = 0;
        feedbackCount = 0;
        councilCount = 0;

        _declareDefaultChannels();
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

    function _declareDefaultChannels() internal {
        _declareChannel(FeedbackChannel.AnonymousSubmission, "Anonymous safe channel for feedback.");
        _declareChannel(FeedbackChannel.DirectCouncilSubmission, "Direct submission to council oversight.");
        _declareChannel(FeedbackChannel.TeamReview, "Team-level review channel.");
        _declareChannel(FeedbackChannel.PublicTransparencyBoard, "Public transparency board for systemic issues.");
        _declareChannel(FeedbackChannel.CrisisFlag, "Immediate flag for crisis or panic decisions.");
    }

    function _declareChannel(FeedbackChannel channelType, string memory description) internal {
        channelCount++;
        channels[channelCount] = Channel(
            channelCount,
            channelType,
            description,
            false,
            block.timestamp
        );
        emit ChannelDeclared(channelCount, channelType);
    }

    function lockChannel(uint256 id) external onlyGuardian {
        Channel storage c = channels[id];
        require(!c.immutableEntry, "Already immutable");
        c.immutableEntry = true;
        emit ChannelLocked(id);
    }

    function fileFeedback(
        FeedbackType feedbackType,
        string calldata details
    ) external {
        feedbackCount++;
        feedbacks[feedbackCount] = Feedback(
            feedbackCount,
            msg.sender,
            feedbackType,
            details,
            FeedbackStatus.Filed,
            0,
            block.timestamp
        );

        emit FeedbackFiled(feedbackCount, feedbackType);
    }

    function beginReview(uint256 feedbackId) external onlyCouncil {
        Feedback storage f = feedbacks[feedbackId];
        require(f.status == FeedbackStatus.Filed, "Not filed");
        f.status = FeedbackStatus.UnderReview;
        emit FeedbackStatusChanged(feedbackId, FeedbackStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 feedbackId) external onlyCouncil {
        Feedback storage f = feedbacks[feedbackId];
        require(f.status == FeedbackStatus.UnderReview, "Not under review");
        f.status = FeedbackStatus.MultiCouncilReview;
        emit FeedbackStatusChanged(feedbackId, FeedbackStatus.MultiCouncilReview);
    }

    function resolveFeedback(uint256 feedbackId) external onlyCouncil {
        Feedback storage f = feedbacks[feedbackId];
        require(f.status == FeedbackStatus.MultiCouncilReview, "Not in council stage");

        f.approvals++;

        if (f.approvals * 2 > councilCount && councilCount > 0) {
            f.status = FeedbackStatus.Resolved;
            emit FeedbackStatusChanged(feedbackId, FeedbackStatus.Resolved);
        }
    }

    function rejectFeedback(uint256 feedbackId) external onlyCouncil {
        Feedback storage f = feedbacks[feedbackId];
        require(
            f.status == FeedbackStatus.Filed ||
            f.status == FeedbackStatus.UnderReview ||
            f.status == FeedbackStatus.MultiCouncilReview,
            "Invalid status"
        );
        f.status = FeedbackStatus.Rejected;
        emit FeedbackStatusChanged(feedbackId, FeedbackStatus.Rejected);
    }
}
