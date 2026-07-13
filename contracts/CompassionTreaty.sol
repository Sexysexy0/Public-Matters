// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Compassion Treaty
/// @notice Unifies compassion commitments into treaty law.
/// @dev Complements JusticeMandala, GraceFramework, and HumanityCharter.

contract CompassionTreaty {
    address public guardian;
    uint256 public treatyCount;
    uint256 public violationCount;
    uint256 public memberCount;

    enum CompassionRule {
        CompassionIsConstitutional,
        EmpathyAnchored,
        CareProtected,
        SolidaritySafeguarded,
        PublicBenefitPriority,
        MandatoryCouncilOversight,
        TreatyBindingAcrossMembers
    }

    enum ViolationType {
        CompassionDenial,
        EmpathySuppression,
        CareBlocked,
        SolidarityErasure,
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
        CompassionRule ruleType;
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

    event RuleDeclared(uint256 indexed id, CompassionRule ruleType);
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
        _declare(CompassionRule.CompassionIsConstitutional, "Compassion is constitutional; denial prohibited.");
        _declare(CompassionRule.EmpathyAnchored, "Empathy is anchored; suppression prohibited.");
        _declare(CompassionRule.CareProtected, "Care is protected; blocking prohibited.");
        _declare(CompassionRule.SolidaritySafeguarded, "Solidarity safeguarded; erasure prohibited.");
        _declare(CompassionRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
        _declare(CompassionRule.MandatoryCouncilOversight, "Council oversight required for compassion enforcement.");
        _declare(CompassionRule.TreatyBindingAcrossMembers, "Treaty rules binding across all members.");
    }

    function _declare(CompassionRule ruleType, string memory description) internal {
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
