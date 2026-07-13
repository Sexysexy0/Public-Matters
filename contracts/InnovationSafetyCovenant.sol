// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Innovation Safety Covenant
/// @notice Protects innovators, founders, creators, and public servants from arbitrary, politically motivated, or vague corruption enforcement.
/// @dev Encodes clear requirements: intent, evidence, transparent review, and public-benefit context before any punitive action.

contract InnovationSafetyCovenant {
    address public guardian;
    uint256 public ruleCount;
    uint256 public caseCount;
    uint256 public councilMemberCount;

    enum RoleType {
        Innovator,
        Creator,
        PublicServant,
        ProcurementOfficer,
        Auditor,
        Council,
        FutureEntity
    }

    enum SafetyRule {
        NoCriminalizationWithoutIntent,
        NoCriminalizationWithoutEvidence,
        NoCriminalizationForGoodFaithDecisions,
        NoPoliticalWeaponization,
        NoProcurementWeaponization,
        MandatoryTransparentReview,
        MandatoryIndependentAudit,
        MandatoryRiskContextEvaluation,
        MandatoryPublicBenefitConsideration,
        MandatoryInnovationProtection
    }

    enum CaseType {
        ArbitraryProsecution,
        PoliticalWeaponization,
        EvidenceLack,
        IntentLack,
        GoodFaithIgnored,
        ProcurementMisinterpretation,
        RiskMisclassification,
        BenefitIgnored
    }

    enum CaseStatus {
        Filed,
        UnderReview,
        Rejected,
        ConfirmedAbuse
    }

    struct Rule {
        uint256 id;
        SafetyRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct CaseLog {
        uint256 id;
        address accuser;
        address accused;
        CaseType caseType;
        string details;
        CaseStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => CaseLog) public cases;
    mapping(address => RoleType) public roles;
    mapping(address => bool) public isCouncilMember;

    event RuleDeclared(uint256 indexed id, SafetyRule ruleType);
    event RuleLocked(uint256 indexed id);
    event CaseFiled(uint256 indexed id, CaseType caseType, address indexed accused);
    event CaseStatusChanged(uint256 indexed id, CaseStatus status);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        ruleCount = 0;
        caseCount = 0;
        councilMemberCount = 0;

        _declareDefaultRules();
    }

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Not authorized: guardian only");
        _;
    }

    modifier onlyCouncil() {
        require(isCouncilMember[msg.sender], "Not authorized: council only");
        _;
    }

    function assignRole(address account, RoleType role) external onlyGuardian {
        roles[account] = role;
    }

    function addCouncilMember(address member) external onlyGuardian {
        require(!isCouncilMember[member], "Already council");
        isCouncilMember[member] = true;
        councilMemberCount++;
        emit CouncilMemberAdded(member);
    }

    function removeCouncilMember(address member) external onlyGuardian {
        require(isCouncilMember[member], "Not council");
        isCouncilMember[member] = false;
        councilMemberCount--;
        emit CouncilMemberRemoved(member);
    }

    function _declareDefaultRules() internal {
        _declareRule(
            SafetyRule.NoCriminalizationWithoutIntent,
            "No person may be prosecuted without proven corrupt intent."
        );
        _declareRule(
            SafetyRule.NoCriminalizationWithoutEvidence,
            "Clear, verifiable evidence is required for any corruption charge."
        );
        _declareRule(
            SafetyRule.NoCriminalizationForGoodFaithDecisions,
            "Good-faith policy or procurement decisions cannot be criminalized."
        );
        _declareRule(
            SafetyRule.NoPoliticalWeaponization,
            "Legal tools may not be used for political targeting."
        );
        _declareRule(
            SafetyRule.NoProcurementWeaponization,
            "Procurement rules may not be retroactively weaponized."
        );
        _declareRule(
            SafetyRule.MandatoryTransparentReview,
            "All serious allegations require transparent multi-body review."
        );
        _declareRule(
            SafetyRule.MandatoryIndependentAudit,
            "Independent audit is required before punitive action."
        );
        _declareRule(
            SafetyRule.MandatoryRiskContextEvaluation,
            "Risk context must be evaluated before judgment."
        );
        _declareRule(
            SafetyRule.MandatoryPublicBenefitConsideration,
            "Public benefit must be weighed in all innovation-related cases."
        );
        _declareRule(
            SafetyRule.MandatoryInnovationProtection,
            "Innovators must be protected from arbitrary enforcement."
        );
    }

    function _declareRule(SafetyRule ruleType, string memory description) internal {
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

    /// @notice File a case claiming abuse of anti-corruption or enforcement against an innovator/public servant.
    function fileCase(
        address accused,
        CaseType caseType,
        string calldata details
    ) external {
        caseCount++;
        cases[caseCount] = CaseLog(
            caseCount,
            msg.sender,
            accused,
            caseType,
            details,
            CaseStatus.Filed,
            0,
            block.timestamp
        );

        emit CaseFiled(caseCount, caseType, accused);
    }

    /// @notice Council begins formal review of a filed case.
    function beginReview(uint256 caseId) external onlyCouncil {
        CaseLog storage c = cases[caseId];
        require(c.status == CaseStatus.Filed, "Case not in filed state");
        c.status = CaseStatus.UnderReview;
        emit CaseStatusChanged(caseId, CaseStatus.UnderReview);
    }

    /// @notice Council member approves that the case represents real abuse (multi-approval style).
    function approveAbuse(uint256 caseId) external onlyCouncil {
        CaseLog storage c = cases[caseId];
        require(c.status == CaseStatus.UnderReview, "Case not under review");
        c.approvals++;

        // Simple threshold: majority of council members
        if (c.approvals * 2 > councilMemberCount && councilMemberCount > 0) {
            c.status = CaseStatus.ConfirmedAbuse;
            emit CaseStatusChanged(caseId, CaseStatus.ConfirmedAbuse);
        }
    }

    /// @notice Council rejects the case (no abuse found).
    function rejectCase(uint256 caseId) external onlyCouncil {
        CaseLog storage c = cases[caseId];
        require(
            c.status == CaseStatus.Filed || c.status == CaseStatus.UnderReview,
            "Invalid status for rejection"
        );
        c.status = CaseStatus.Rejected;
        emit CaseStatusChanged(caseId, CaseStatus.Rejected);
    }

    /// @notice Helper: view if a case is confirmed as abuse of innovation safety.
    function isConfirmedAbuse(uint256 caseId) external view returns (bool) {
        return cases[caseId].status == CaseStatus.ConfirmedAbuse;
    }
}
