// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Bureaucratic Accountability Covenant
/// @notice Holds bureaucrats, auditors, investigators, and enforcement bodies accountable for selective enforcement, political targeting, malicious interpretation, and abuse of discretion.
/// @dev Works with InnovationSafetyCovenant, ProcurementClarity, AntiWeaponization, RiskContextReview, PublicBenefitOracle, and InnovationMeritShield.

contract BureaucraticAccountability {
    address public guardian;
    uint256 public ruleCount;
    uint256 public caseCount;
    uint256 public councilCount;

    enum RoleType {
        Bureaucrat,
        Auditor,
        Investigator,
        PublicServant,
        Innovator,
        Council,
        Oversight,
        FutureEntity
    }

    enum AccountabilityRule {
        NoSelectiveEnforcement,
        NoMaliciousInterpretation,
        NoPoliticalTargeting,
        NoRetroactivePunishment,
        NoEvidenceSuppression,
        NoRiskMisclassification,
        NoMeritSuppression,
        NoPublicBenefitSuppression,
        MandatoryTransparency,
        MandatoryMultiCouncilOversight
    }

    enum AbuseType {
        SelectiveEnforcement,
        MaliciousInterpretation,
        PoliticalTargeting,
        RetroactivePunishment,
        EvidenceSuppression,
        RiskMisclassification,
        MeritSuppression,
        PublicBenefitSuppression,
        AbuseOfDiscretion
    }

    enum CaseStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        ConfirmedAbuse
    }

    struct Rule {
        uint256 id;
        AccountabilityRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct AbuseCase {
        uint256 id;
        address accuser;
        address accused;
        AbuseType abuseType;
        string details;
        CaseStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => AbuseCase) public cases;
    mapping(address => RoleType) public roles;
    mapping(address => bool) public councilMember;

    event RuleDeclared(uint256 indexed id, AccountabilityRule ruleType);
    event RuleLocked(uint256 indexed id);
    event AbuseFiled(uint256 indexed id, AbuseType abuseType);
    event CaseStatusChanged(uint256 indexed id, CaseStatus status);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        ruleCount = 0;
        caseCount = 0;
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
        _declareRule(AccountabilityRule.NoSelectiveEnforcement, "Bureaucrats cannot selectively enforce laws.");
        _declareRule(AccountabilityRule.NoMaliciousInterpretation, "Rules cannot be interpreted maliciously.");
        _declareRule(AccountabilityRule.NoPoliticalTargeting, "Bureaucrats cannot target individuals politically.");
        _declareRule(AccountabilityRule.NoRetroactivePunishment, "No retroactive punishment allowed.");
        _declareRule(AccountabilityRule.NoEvidenceSuppression, "Evidence cannot be hidden or suppressed.");
        _declareRule(AccountabilityRule.NoRiskMisclassification, "Risk cannot be misclassified as wrongdoing.");
        _declareRule(AccountabilityRule.NoMeritSuppression, "Merit cannot be ignored or suppressed.");
        _declareRule(AccountabilityRule.NoPublicBenefitSuppression, "Public benefit cannot be ignored.");
        _declareRule(AccountabilityRule.MandatoryTransparency, "All actions must be transparent.");
        _declareRule(AccountabilityRule.MandatoryMultiCouncilOversight, "All abuse cases require multi-council oversight.");
    }

    function _declareRule(AccountabilityRule ruleType, string memory description) internal {
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

    function fileAbuse(
        address accused,
        AbuseType abuseType,
        string calldata details
    ) external {
        caseCount++;
        cases[caseCount] = AbuseCase(
            caseCount,
            msg.sender,
            accused,
            abuseType,
            details,
            CaseStatus.Filed,
            0,
            block.timestamp
        );

        emit AbuseFiled(caseCount, abuseType);
    }

    function beginReview(uint256 caseId) external onlyCouncil {
        AbuseCase storage c = cases[caseId];
        require(c.status == CaseStatus.Filed, "Not filed");
        c.status = CaseStatus.UnderReview;
        emit CaseStatusChanged(caseId, CaseStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 caseId) external onlyCouncil {
        AbuseCase storage c = cases[caseId];
        require(c.status == CaseStatus.UnderReview, "Not under review");
        c.status = CaseStatus.MultiCouncilReview;
        emit CaseStatusChanged(caseId, CaseStatus.MultiCouncilReview);
    }

    function approveAbuse(uint256 caseId) external onlyCouncil {
        AbuseCase storage c = cases[caseId];
        require(c.status == CaseStatus.MultiCouncilReview, "Not in council stage");

        c.approvals++;

        if (c.approvals * 2 > councilCount && councilCount > 0) {
            c.status = CaseStatus.ConfirmedAbuse;
            emit CaseStatusChanged(caseId, CaseStatus.ConfirmedAbuse);
        }
    }

    function rejectCase(uint256 caseId) external onlyCouncil {
        AbuseCase storage c = cases[caseId];
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
