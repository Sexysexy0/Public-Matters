// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Delegation Framework
/// @notice Encodes systemic delegation and empowerment of sub-leaders.
/// @dev Complements GovernanceCharter, RiskContextReview, and InnovationFreedomCharter.

contract DelegationFramework {
    address public guardian;
    uint256 public frameworkCount;
    uint256 public violationCount;
    uint256 public delegateCount;

    enum DelegationRule {
        DelegationIsConstitutional,
        AuthorityAnchored,
        EmpowermentProtected,
        AccountabilitySafeguarded,
        PublicBenefitPriority,
        MandatoryCouncilOversight,
        TransparencyInDelegationSystems
    }

    enum ViolationType {
        DelegationDenial,
        AuthoritySuppression,
        EmpowermentBlocked,
        AccountabilityErasure,
        CouncilBypass,
        PublicBenefitFailure,
        TransparencyFailure
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
        DelegationRule ruleType;
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
    mapping(address => bool) public delegates;

    event RuleDeclared(uint256 indexed id, DelegationRule ruleType);
    event RuleLocked(uint256 indexed id);
    event ViolationFiled(uint256 indexed id, ViolationType violationType);
    event CaseStatusChanged(uint256 indexed id, CaseStatus status);
    event DelegateAdded(address indexed member);
    event DelegateRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        frameworkCount = 0;
        violationCount = 0;
        delegateCount = 0;

        _declareDefaultRules();
    }

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Guardian only");
        _;
    }

    modifier onlyDelegate() {
        require(delegates[msg.sender], "Delegate only");
        _;
    }

    function addDelegate(address member) external onlyGuardian {
        require(!delegates[member], "Already delegate");
        delegates[member] = true;
        delegateCount++;
        emit DelegateAdded(member);
    }

    function removeDelegate(address member) external onlyGuardian {
        require(delegates[member], "Not delegate");
        delegates[member] = false;
        delegateCount--;
        emit DelegateRemoved(member);
    }

    function _declareDefaultRules() internal {
        _declare(DelegationRule.DelegationIsConstitutional, "Delegation is constitutional; denial prohibited.");
        _declare(DelegationRule.AuthorityAnchored, "Authority is anchored; suppression prohibited.");
        _declare(DelegationRule.EmpowermentProtected, "Empowerment protected; blocking prohibited.");
        _declare(DelegationRule.AccountabilitySafeguarded, "Accountability safeguarded; erasure prohibited.");
        _declare(DelegationRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
        _declare(DelegationRule.MandatoryCouncilOversight, "Council oversight required for delegation enforcement.");
        _declare(DelegationRule.TransparencyInDelegationSystems, "Delegation systems must be transparent.");
    }

    function _declare(DelegationRule ruleType, string memory description) internal {
        frameworkCount++;
        rules[frameworkCount] = Rule(
            frameworkCount,
            ruleType,
            description,
            false,
            block.timestamp
        );
        emit RuleDeclared(frameworkCount, ruleType);
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

    function beginReview(uint256 violationId) external onlyDelegate {
        Violation storage v = violations[violationId];
        require(v.status == CaseStatus.Filed, "Not filed");
        v.status = CaseStatus.UnderReview;
        emit CaseStatusChanged(violationId, CaseStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 violationId) external onlyDelegate {
        Violation storage v = violations[violationId];
        require(v.status == CaseStatus.UnderReview, "Not under review");
        v.status = CaseStatus.MultiCouncilReview;
        emit CaseStatusChanged(violationId, CaseStatus.MultiCouncilReview);
    }

    function approveViolation(uint256 violationId) external onlyDelegate {
        Violation storage v = violations[violationId];
        require(v.status == CaseStatus.MultiCouncilReview, "Not in council stage");

        v.approvals++;

        if (v.approvals * 2 > delegateCount && delegateCount > 0) {
            v.status = CaseStatus.ConfirmedViolation;
            emit CaseStatusChanged(violationId, CaseStatus.ConfirmedViolation);
        }
    }

    function rejectViolation(uint256 violationId) external onlyDelegate {
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
