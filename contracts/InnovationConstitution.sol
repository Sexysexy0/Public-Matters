// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Innovation Constitution
/// @notice Unifies all innovation protections, rights, safeguards, and governance rules into one constitutional covenant.
/// @dev Integrates InnovationSafetyCovenant, ProcurementClarity, AntiWeaponization, RiskContextReview,
///      PublicBenefitOracle, InnovationMeritShield, BureaucraticAccountability, and InnovationFreedomCharter.

contract InnovationConstitution {
    address public guardian;
    uint256 public articleCount;
    uint256 public violationCount;
    uint256 public councilCount;

    enum RoleType {
        Innovator,
        Creator,
        Engineer,
        Founder,
        PublicServant,
        Council,
        Oversight,
        FutureEntity
    }

    enum Article {
        InnovationIsAConstitutionalRight,
        InnovationMustBeProtected,
        InnovationCannotBeCriminalized,
        GoodFaithIsPresumed,
        RiskIsNotCorruption,
        MeritMustBeRecognized,
        PublicBenefitOverridesPunishment,
        ProcurementMustBeClear,
        GovernanceCannotBeWeaponized,
        BureaucracyMustBeAccountable,
        TransparencyIsMandatory,
        MultiCouncilReviewRequired,
        NoSelectiveEnforcement,
        NoPoliticalTargeting,
        NoMaliciousInterpretation,
        NoRetroactivePunishment,
        NoSuppressionOfInnovation,
        NoRetaliationAgainstInnovators,
        NoFearBasedGovernance,
        UnifiedInnovationProtection
    }

    enum ViolationType {
        InnovationSuppression,
        Retaliation,
        FearInducement,
        WeaponizedGovernance,
        MeritErasure,
        PublicBenefitErasure,
        RiskMisclassification,
        ProcurementAbuse,
        BureaucraticAbuse,
        GoodFaithIgnored,
        TransparencyViolation,
        SelectiveEnforcement,
        PoliticalTargeting,
        MaliciousInterpretation,
        RetroactivePunishment,
        ConstitutionalViolation
    }

    enum CaseStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        ConfirmedViolation
    }

    struct ArticleEntry {
        uint256 id;
        Article articleType;
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

    mapping(uint256 => ArticleEntry) public articles;
    mapping(uint256 => Violation) public violations;
    mapping(address => RoleType) public roles;
    mapping(address => bool) public councilMember;

    event ArticleDeclared(uint256 indexed id, Article articleType);
    event ArticleLocked(uint256 indexed id);
    event ViolationFiled(uint256 indexed id, ViolationType violationType);
    event CaseStatusChanged(uint256 indexed id, CaseStatus status);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        articleCount = 0;
        violationCount = 0;
        councilCount = 0;

        _declareArticles();
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

    function _declareArticles() internal {
        _declare(Article.InnovationIsAConstitutionalRight, "Innovation is a constitutional right.");
        _declare(Article.InnovationMustBeProtected, "Innovation must be protected at all levels.");
        _declare(Article.InnovationCannotBeCriminalized, "Innovation cannot be criminalized.");
        _declare(Article.GoodFaithIsPresumed, "Good faith is the default presumption.");
        _declare(Article.RiskIsNotCorruption, "Risk-taking is not corruption.");
        _declare(Article.MeritMustBeRecognized, "Merit must be recognized and protected.");
        _declare(Article.PublicBenefitOverridesPunishment, "Public benefit overrides punitive action.");
        _declare(Article.ProcurementMustBeClear, "Procurement rules must be clear and objective.");
        _declare(Article.GovernanceCannotBeWeaponized, "Governance cannot be weaponized.");
        _declare(Article.BureaucracyMustBeAccountable, "Bureaucracy must be accountable.");
        _declare(Article.TransparencyIsMandatory, "Transparency is mandatory.");
        _declare(Article.MultiCouncilReviewRequired, "Multi-council review is required for all cases.");
        _declare(Article.NoSelectiveEnforcement, "Selective enforcement is prohibited.");
        _declare(Article.NoPoliticalTargeting, "Political targeting is prohibited.");
        _declare(Article.NoMaliciousInterpretation, "Malicious interpretation is prohibited.");
        _declare(Article.NoRetroactivePunishment, "Retroactive punishment is prohibited.");
        _declare(Article.NoSuppressionOfInnovation, "Innovation cannot be suppressed.");
        _declare(Article.NoRetaliationAgainstInnovators, "Retaliation against innovators is prohibited.");
        _declare(Article.NoFearBasedGovernance, "Fear-based governance is prohibited.");
        _declare(Article.UnifiedInnovationProtection, "All innovation protections are unified under this constitution.");
    }

    function _declare(Article articleType, string memory description) internal {
        articleCount++;
        articles[articleCount] = ArticleEntry(
            articleCount,
            articleType,
            description,
            false,
            block.timestamp
        );
        emit ArticleDeclared(articleCount, articleType);
    }

    function lockArticle(uint256 id) external onlyGuardian {
        ArticleEntry storage a = articles[id];
        require(!a.immutableEntry, "Already immutable");
        a.immutableEntry = true;
        emit ArticleLocked(id);
    }

    function fileViolation(
        address accused,
        ViolationType violationType,
        string calldata details
    ) external {
        violationCount++;
        violations[violationCount] = Violation(
            violationCount,
            msg.sender,
            accused,
            violationType,
            details,
            CaseStatus.Filed,
            0,
            block.timestamp
        );

        emit ViolationFiled(violationCount, violationType);
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
