// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Global Wellbeing Treaty
/// @notice Unifies wellbeing commitments into treaty law.
/// @dev Complements WellbeingFramework, DignityCharter, and HopeFramework.

contract GlobalWellbeingTreaty {
    address public guardian;
    uint256 public treatyCount;
    uint256 public violationCount;
    uint256 public memberCount;

    enum WellbeingRule {
        WellbeingIsConstitutional,
        HealthProtected,
        DignityAnchored,
        ResilienceSafeguarded,
        OptimismProtected,
        PublicBenefitPriority,
        MandatoryCouncilOversight,
        TreatyBindingAcrossMembers
    }

    enum ViolationType {
        WellbeingDenial,
        HealthSuppression,
        DignityErasure,
        ResilienceBlocked,
        OptimismErasure,
        CouncilBypass,
        PublicBenefitFailure,
        TreatyBreach
    }

    enum CaseStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        ConfirmedViolation
    }

    struct Rule {
        uint256 id;
        WellbeingRule ruleType;
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

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => Violation) public violations;
    mapping(address => bool) public treatyMembers;

    event RuleDeclared(uint256 indexed id, WellbeingRule ruleType);
    event RuleLocked(uint256 indexed id);
    event ViolationFiled(uint256 indexed id, ViolationType violationType);
    event CaseStatusChanged(uint256 indexed id, CaseStatus status);
    event TreatyMemberAdded(address indexed member);
    event TreatyMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        treatyCount = 0;
        violationCount = 0;
        memberCount = 0;

        _declareDefaultRules();
    }

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Guardian only");
        _;
    }

    modifier onlyMember() {
        require(treatyMembers[msg.sender], "Treaty member only");
        _;
    }

    function addTreatyMember(address member) external onlyGuardian {
        require(!treatyMembers[member], "Already member");
        treatyMembers[member] = true;
        memberCount++;
        emit TreatyMemberAdded(member);
    }

    function removeTreatyMember(address member) external onlyGuardian {
        require(treatyMembers[member], "Not member");
        treatyMembers[member] = false;
        memberCount--;
        emit TreatyMemberRemoved(member);
    }

    function _declareDefaultRules() internal {
        _declare(WellbeingRule.WellbeingIsConstitutional, "Wellbeing is constitutional; denial prohibited.");
        _declare(WellbeingRule.HealthProtected, "Health is protected; systemic safeguards required.");
        _declare(WellbeingRule.DignityAnchored, "Dignity is anchored; erasure prohibited.");
        _declare(WellbeingRule.ResilienceSafeguarded, "Resilience safeguarded; bottom rock joy valid.");
        _declare(WellbeingRule.OptimismProtected, "Optimism protected; positivity safeguarded.");
        _declare(WellbeingRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
        _declare(WellbeingRule.MandatoryCouncilOversight, "Council oversight required for wellbeing enforcement.");
        _declare(WellbeingRule.TreatyBindingAcrossMembers, "Treaty rules binding across all members.");
    }

    function _declare(WellbeingRule ruleType, string memory description) internal {
        treatyCount++;
        rules[treatyCount] = Rule(
            treatyCount,
            ruleType,
            description,
            false,
            block.timestamp
        );
        emit RuleDeclared(treatyCount, ruleType);
    }

    function lockRule(uint256 id) external onlyGuardian {
        Rule storage r = rules[id];
        require(!r.immutableEntry, "Already immutable");
        r.immutableEntry = true;
        emit RuleLocked(id);
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

    function beginReview(uint256 violationId) external onlyMember {
        Violation storage v = violations[violationId];
        require(v.status == CaseStatus.Filed, "Not filed");
        v.status = CaseStatus.UnderReview;
        emit CaseStatusChanged(violationId, CaseStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 violationId) external onlyMember {
        Violation storage v = violations[violationId];
        require(v.status == CaseStatus.UnderReview, "Not under review");
        v.status = CaseStatus.MultiCouncilReview;
        emit CaseStatusChanged(violationId, CaseStatus.MultiCouncilReview);
    }

    function approveViolation(uint256 violationId) external onlyMember {
        Violation storage v = violations[violationId];
        require(v.status == CaseStatus.MultiCouncilReview, "Not in council stage");

        v.approvals++;

        if (v.approvals * 2 > memberCount && memberCount > 0) {
            v.status = CaseStatus.ConfirmedViolation;
            emit CaseStatusChanged(violationId, CaseStatus.ConfirmedViolation);
        }
    }

    function rejectViolation(uint256 violationId) external onlyMember {
        Violation storage v = violations[violationId];
        require(
            v.status == CaseStatus.Filed ||
            v.status == CaseStatus.UnderReview ||
            v.status == CaseStatus.MultiCouncilReview,
            "Invalid status"
        );
        v.status = CaseStatus.Rejected;
        emit CaseStatusChanged(violationId, CaseStatus.Rejected);
    }
}
