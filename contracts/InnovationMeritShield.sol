// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Innovation Merit Shield
/// @notice Protects innovators, founders, creators, and public servants whose work demonstrates merit, public benefit, or societal value.
/// @dev Prevents punishment, targeting, or prosecution of individuals whose contributions meet merit thresholds.

contract InnovationMeritShield {
    address public guardian;
    uint256 public meritCount;
    uint256 public caseCount;
    uint256 public councilCount;

    enum RoleType {
        Innovator,
        Creator,
        Engineer,
        PublicServant,
        Council,
        Oversight,
        FutureEntity
    }

    enum MeritMetric {
        JobCreation,
        EconomicContribution,
        TechnologyAdvancement,
        EducationImpact,
        PublicServiceImprovement,
        SystemModernization,
        SocialBenefit,
        CulturalContribution,
        LongTermValue,
        CrisisContribution
    }

    enum MeritCaseType {
        MeritIgnored,
        MeritPunished,
        MeritMisclassified,
        MeritUndervalued,
        MeritWeaponized
    }

    enum CaseStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        ConfirmedMeritAbuse
    }

    struct Merit {
        uint256 id;
        MeritMetric metricType;
        string description;
        uint256 score; // 0–100 merit score
        bool immutableEntry;
        uint256 timestamp;
    }

    struct MeritCase {
        uint256 id;
        address accuser;
        address accused;
        MeritCaseType caseType;
        string details;
        uint256 meritScore;
        CaseStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Merit) public merits;
    mapping(uint256 => MeritCase) public cases;
    mapping(address => RoleType) public roles;
    mapping(address => bool) public councilMember;

    event MeritDeclared(uint256 indexed id, MeritMetric metricType);
    event MeritLocked(uint256 indexed id);
    event MeritCaseFiled(uint256 indexed id, MeritCaseType caseType);
    event CaseStatusChanged(uint256 indexed id, CaseStatus status);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        meritCount = 0;
        caseCount = 0;
        councilCount = 0;

        _declareDefaultMerits();
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

    function _declareDefaultMerits() internal {
        _declareMerit(MeritMetric.JobCreation, "Created jobs and economic opportunities.", 80);
        _declareMerit(MeritMetric.EconomicContribution, "Contributed significantly to the economy.", 75);
        _declareMerit(MeritMetric.TechnologyAdvancement, "Advanced national or global technology.", 85);
        _declareMerit(MeritMetric.EducationImpact, "Improved education systems or access.", 70);
        _declareMerit(MeritMetric.PublicServiceImprovement, "Improved public services.", 65);
        _declareMerit(MeritMetric.SystemModernization, "Modernized outdated systems.", 80);
        _declareMerit(MeritMetric.SocialBenefit, "Created social or community benefit.", 60);
        _declareMerit(MeritMetric.CulturalContribution, "Contributed to cultural progress.", 55);
        _declareMerit(MeritMetric.LongTermValue, "Created long-term national value.", 75);
        _declareMerit(MeritMetric.CrisisContribution, "Helped during crisis or emergency.", 85);
    }

    function _declareMerit(
        MeritMetric metricType,
        string memory description,
        uint256 score
    ) internal {
        meritCount++;
        merits[meritCount] = Merit(
            meritCount,
            metricType,
            description,
            score,
            false,
            block.timestamp
        );
        emit MeritDeclared(meritCount, metricType);
    }

    function lockMerit(uint256 id) external onlyGuardian {
        Merit storage m = merits[id];
        require(!m.immutableEntry, "Already immutable");
        m.immutableEntry = true;
        emit MeritLocked(id);
    }

    function fileMeritCase(
        address accused,
        MeritCaseType caseType,
        string calldata details,
        uint256 meritScore
    ) external {
        require(meritScore <= 100, "Score must be 0–100");

        caseCount++;
        cases[caseCount] = MeritCase(
            caseCount,
            msg.sender,
            accused,
            caseType,
            details,
            meritScore,
            CaseStatus.Filed,
            0,
            block.timestamp
        );

        emit MeritCaseFiled(caseCount, caseType);
    }

    function beginReview(uint256 caseId) external onlyCouncil {
        MeritCase storage c = cases[caseId];
        require(c.status == CaseStatus.Filed, "Not filed");
        c.status = CaseStatus.UnderReview;
        emit CaseStatusChanged(caseId, CaseStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 caseId) external onlyCouncil {
        MeritCase storage c = cases[caseId];
        require(c.status == CaseStatus.UnderReview, "Not under review");
        c.status = CaseStatus.MultiCouncilReview;
        emit CaseStatusChanged(caseId, CaseStatus.MultiCouncilReview);
    }

    function approveMeritAbuse(uint256 caseId) external onlyCouncil {
        MeritCase storage c = cases[caseId];
        require(c.status == CaseStatus.MultiCouncilReview, "Not in council stage");

        c.approvals++;

        if (c.approvals * 2 > councilCount && councilCount > 0 && c.meritScore >= 60) {
            c.status = CaseStatus.ConfirmedMeritAbuse;
            emit CaseStatusChanged(caseId, CaseStatus.ConfirmedMeritAbuse);
        }
    }

    function rejectCase(uint256 caseId) external onlyCouncil {
        MeritCase storage c = cases[caseId];
        require(
            c.status == CaseStatus.Filed ||
            c.status == CaseStatus.UnderReview ||
            c.status == CaseStatus.MultiCouncilReview,
            "Invalid status"
        );
        c.status = CaseStatus.Rejected;
        emit CaseStatusChanged(caseId, CaseStatus.Rejected);
    }
}
