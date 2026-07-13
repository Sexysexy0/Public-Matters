// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Global Innovation Treaty
/// @notice Establishes international covenant principles for innovation governance.
/// @dev Integrates InnovationConstitution, BrandTrustCovenant, CrisisLeadershipFramework, and TransparencyCulture into a global treaty.

contract GlobalInnovationTreaty {
    address public guardian;
    uint256 public articleCount;
    uint256 public violationCount;
    uint256 public councilCount;

    enum RoleType {
        Nation,
        Innovator,
        Founder,
        PublicServant,
        Council,
        Oversight,
        TreatyMember
    }

    enum TreatyArticle {
        InnovationIsUniversalRight,
        RiskIsNotCorruption,
        MeritIsProtected,
        PublicBenefitOverridesPunishment,
        TransparencyIsMandatory,
        TrustIsConstitutional,
        NoWeaponizedGovernance,
        NoRetaliationAgainstInnovators,
        NoFearBasedGovernance,
        MandatoryMultiCouncilOversight,
        MandatoryRootCausePublication,
        MandatoryPublicClarification,
        GlobalInnovationProtection
    }

    enum TreatyViolation {
        InnovationSuppression,
        Retaliation,
        FearInducement,
        WeaponizedGovernance,
        MeritErasure,
        PublicBenefitErasure,
        RiskMisclassification,
        TransparencyFailure,
        TrustErosion,
        CouncilBypass,
        RootCauseHidden,
        ClarificationFailure
    }

    enum CaseStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        ConfirmedViolation
    }

    struct Article {
        uint256 id;
        TreatyArticle articleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct Violation {
        uint256 id;
        address accuser;
        address accused;
        TreatyViolation violationType;
        string details;
        CaseStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Article) public articles;
    mapping(uint256 => Violation) public violations;
    mapping(address => RoleType) public roles;
    mapping(address => bool) public councilMember;

    event ArticleDeclared(uint256 indexed id, TreatyArticle articleType);
    event ArticleLocked(uint256 indexed id);
    event ViolationFiled(uint256 indexed id, TreatyViolation violationType);
    event CaseStatusChanged(uint256 indexed id, CaseStatus status);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        articleCount = 0;
        violationCount = 0;
        councilCount = 0;

        _declareDefaultArticles();
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

    function _declareDefaultArticles() internal {
        _declare(TreatyArticle.InnovationIsUniversalRight, "Innovation is a universal right.");
        _declare(TreatyArticle.RiskIsNotCorruption, "Risk-taking is not corruption.");
        _declare(TreatyArticle.MeritIsProtected, "Merit is protected internationally.");
        _declare(TreatyArticle.PublicBenefitOverridesPunishment, "Public benefit overrides punitive action.");
        _declare(TreatyArticle.TransparencyIsMandatory, "Transparency is mandatory across nations.");
        _declare(TreatyArticle.TrustIsConstitutional, "Trust is constitutional in global governance.");
        _declare(TreatyArticle.NoWeaponizedGovernance, "Governance cannot be weaponized internationally.");
        _declare(TreatyArticle.NoRetaliationAgainstInnovators, "No retaliation against innovators globally.");
        _declare(TreatyArticle.NoFearBasedGovernance, "Fear-based governance is prohibited globally.");
        _declare(TreatyArticle.MandatoryMultiCouncilOversight, "Multi-council oversight is mandatory across treaty members.");
        _declare(TreatyArticle.MandatoryRootCausePublication, "Root cause analysis must be published internationally.");
        _declare(TreatyArticle.MandatoryPublicClarification, "Public clarification is mandatory after global incidents.");
        _declare(TreatyArticle.GlobalInnovationProtection, "All innovation protections are unified under this treaty.");
    }

    function _declare(TreatyArticle articleType, string memory description) internal {
        articleCount++;
        articles[articleCount] = Article(
            articleCount,
            articleType,
            description,
            false,
            block.timestamp
        );
        emit ArticleDeclared(articleCount, articleType);
    }

    function lockArticle(uint256 id) external onlyGuardian {
        Article storage a = articles[id];
        require(!a.immutableEntry, "Already immutable");
        a.immutableEntry = true;
        emit ArticleLocked(id);
    }

    function fileViolation(
        address accused,
        TreatyViolation violationType,
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
