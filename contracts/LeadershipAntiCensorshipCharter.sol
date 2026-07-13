// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Leadership Anti-Censorship Charter
/// @notice Prevents leaders, founders, creators, and public figures from weaponizing legal tools (DMCA, takedowns, strikes) to suppress criticism.
/// @dev Encodes transparency, accountability, and constructive feedback as constitutional leadership principles.

contract LeadershipAntiCensorshipCharter {
    address public guardian;
    uint256 public principleCount;
    uint256 public caseCount;
    uint256 public councilCount;

    enum RoleType {
        Leader,
        Founder,
        Creator,
        PublicFigure,
        Council,
        Oversight,
        FutureEntity
    }

    enum Principle {
        NoCensorshipOfCriticism,
        NoWeaponizedDMCA,
        NoNarrativeSuppression,
        NoRetaliationAgainstCommentary,
        TransparencyOverForce,
        FixRootCauseNotSymptom,
        FeedbackIsDiagnosticData,
        PublicDialogueIsProtected,
        NoFearBasedReactions,
        MandatoryCalmLeadershipReview
    }

    enum ViolationType {
        CensorshipAttempt,
        DMCAWeaponization,
        CriticismSuppression,
        RetaliationAgainstCommentary,
        PanicDecision,
        NarrativeManipulation,
        TransparencyViolation,
        FearBasedLeadership,
        RootCauseIgnored
    }

    enum CaseStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        ConfirmedViolation
    }

    struct PrincipleEntry {
        uint256 id;
        Principle principleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct Violation {
        uint256 id;
        address accuser;
        address accused;
        ViolationType violationType;
        string details;
        CaseStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => PrincipleEntry) public principles;
    mapping(uint256 => Violation> public violations;
    mapping(address => RoleType) public roles;
    mapping(address => bool) public councilMember;

    event PrincipleDeclared(uint256 indexed id, Principle principleType);
    event PrincipleLocked(uint256 indexed id);
    event ViolationFiled(uint256 indexed id, ViolationType violationType);
    event CaseStatusChanged(uint256 indexed id, CaseStatus status);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        principleCount = 0;
        caseCount = 0;
        councilCount = 0;

        _declarePrinciples();
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

    function _declarePrinciples() internal {
        _declare(Principle.NoCensorshipOfCriticism, "Criticism cannot be censored.");
        _declare(Principle.NoWeaponizedDMCA, "DMCA cannot be used to silence commentary.");
        _declare(Principle.NoNarrativeSuppression, "Leaders cannot suppress narratives.");
        _declare(Principle.NoRetaliationAgainstCommentary, "No retaliation for public commentary.");
        _declare(Principle.TransparencyOverForce, "Transparency is preferred over legal force.");
        _declare(Principle.FixRootCauseNotSymptom, "Leaders must fix root causes, not hide symptoms.");
        _declare(Principle.FeedbackIsDiagnosticData, "Criticism is diagnostic data, not an attack.");
        _declare(Principle.PublicDialogueIsProtected, "Public dialogue is protected.");
        _declare(Principle.NoFearBasedReactions, "Fear-based leadership reactions are prohibited.");
        _declare(Principle.MandatoryCalmLeadershipReview, "All controversies require calm review before action.");
    }

    function _declare(Principle principleType, string memory description) internal {
        principleCount++;
        principles[principleCount] = PrincipleEntry(
            principleCount,
            principleType,
            description,
            false,
            block.timestamp
        );
        emit PrincipleDeclared(principleCount, principleType);
    }

    function lockPrinciple(uint256 id) external onlyGuardian {
        PrincipleEntry storage p = principles[id];
        require(!p.immutableEntry, "Already immutable");
        p.immutableEntry = true;
        emit PrincipleLocked(id);
    }

    function fileViolation(
        address accused,
        ViolationType violationType,
        string calldata details
    ) external {
        caseCount++;
        violations[caseCount] = Violation(
            caseCount,
            msg.sender,
            accused,
            violationType,
            details,
            CaseStatus.Filed,
            0,
            block.timestamp
        );

        emit ViolationFiled(caseCount, violationType);
    }

    function beginReview(uint256 caseId) external onlyCouncil {
        Violation storage v = violations[caseId];
        require(v.status == CaseStatus.Filed, "Not filed");
        v.status = CaseStatus.UnderReview;
        emit CaseStatusChanged(caseId, CaseStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 caseId) external onlyCouncil {
        Violation storage v = violations[caseId];
        require(v.status == CaseStatus.UnderReview, "Not under review");
        v.status = CaseStatus.MultiCouncilReview;
        emit CaseStatusChanged(caseId, CaseStatus.MultiCouncilReview);
    }

    function approveViolation(uint256 caseId) external onlyCouncil {
        Violation storage v = violations[caseId];
        require(v.status == CaseStatus.MultiCouncilReview, "Not in council stage");

        v.approvals++;

        if (v.approvals * 2 > councilCount && councilCount > 0) {
            v.status = CaseStatus.ConfirmedViolation;
            emit CaseStatusChanged(caseId, CaseStatus.ConfirmedViolation);
        }
    }

    function rejectCase(uint256 caseId) external onlyCouncil {
        Violation storage v = violations[caseId];
        require(
            v.status == CaseStatus.Filed ||
            v.status == CaseStatus.UnderReview ||
            v.status == CaseStatus.MultiCouncilReview,
            "Invalid status"
        );
        v.status = CaseStatus.Rejected;
        emit CaseStatusChanged(caseId, CaseStatus.Rejected);
    }
}
