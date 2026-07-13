// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Anti Weaponization Covenant
/// @notice Prevents political actors, agencies, or bureaucrats from weaponizing laws, audits, procurement rules, or enforcement mechanisms.
/// @dev Works together with InnovationSafetyCovenant and ProcurementClarity to ensure governance cannot be used as a political weapon.

contract AntiWeaponization {
    address public guardian;
    uint256 public ruleCount;
    uint256 public caseCount;
    uint256 public councilCount;

    enum RoleType {
        Innovator,
        PublicServant,
        Auditor,
        Investigator,
        Council,
        Oversight,
        FutureEntity
    }

    enum WeaponizationRule {
        NoSelectiveEnforcement,
        NoPoliticalTargeting,
        NoMaliciousInterpretation,
        NoRetroactivePunishment,
        NoMediaManipulation,
        NoProcurementWeaponization,
        NoAuditWeaponization,
        MandatoryIndependentOversight,
        MandatoryMultiCouncilReview,
        MandatoryIntentVerification
    }

    enum AbuseType {
        SelectiveEnforcement,
        PoliticalTargeting,
        MaliciousInterpretation,
        RetroactivePunishment,
        MediaWeaponization,
        ProcurementWeaponization,
        AuditWeaponization,
        IntentIgnored,
        EvidenceIgnored
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
        WeaponizationRule ruleType;
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

    event RuleDeclared(uint256 indexed id, WeaponizationRule ruleType);
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
        _declareRule(
            WeaponizationRule.NoSelectiveEnforcement,
            "Laws cannot be selectively enforced against specific individuals."
        );
        _declareRule(
            WeaponizationRule.NoPoliticalTargeting,
            "Legal tools cannot be used for political targeting."
        );
        _declareRule(
            WeaponizationRule.NoMaliciousInterpretation,
            "Rules cannot be interpreted maliciously to create artificial violations."
        );
        _declareRule(
            WeaponizationRule.NoRetroactivePunishment,
            "No retroactive punishment for rules that did not exist at the time."
        );
        _declareRule(
            WeaponizationRule.NoMediaManipulation,
            "Media narratives cannot be weaponized to influence legal outcomes."
        );
        _declareRule(
            WeaponizationRule.NoProcurementWeaponization,
            "Procurement rules cannot be twisted to frame innovators."
        );
        _declareRule(
            WeaponizationRule.NoAuditWeaponization,
            "Audits cannot be weaponized for political or personal gain."
        );
        _declareRule(
            WeaponizationRule.MandatoryIndependentOversight,
            "Independent oversight required for all major allegations."
        );
        _declareRule(
            WeaponizationRule.MandatoryMultiCouncilReview,
            "All abuse cases require multi-council approval."
        );
        _declareRule(
            WeaponizationRule.MandatoryIntentVerification,
            "Intent must be verified before any punitive action."
        );
    }

    function _declareRule(WeaponizationRule ruleType, string memory description) internal {
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
