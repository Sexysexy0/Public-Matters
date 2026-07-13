// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Procurement Clarity Covenant
/// @notice Establishes clear, objective, measurable procurement rules to prevent vague interpretation, political weaponization, and arbitrary corruption charges.
/// @dev This contract pairs with InnovationSafetyCovenant to ensure innovators and public servants cannot be punished for good-faith procurement decisions.

contract ProcurementClarity {
    address public guardian;
    uint256 public ruleCount;
    uint256 public reviewCount;

    enum RoleType {
        ProcurementOfficer,
        Auditor,
        Innovator,
        PublicServant,
        Council,
        FutureEntity
    }

    enum ClarityRule {
        ObjectiveSpecsRequired,
        MultiVendorCompatibility,
        TransparentCriteria,
        PublicJustificationRequired,
        IndependentAuditRequired,
        NoRetroactiveRuleChange,
        NoSpecManipulation,
        NoPoliticalInterference,
        RiskContextRequired,
        PublicBenefitRequired
    }

    enum ReviewType {
        SpecChallenge,
        VendorChallenge,
        CriteriaChallenge,
        AuditChallenge,
        PoliticalInterference,
        RetroactiveManipulation
    }

    enum ReviewStatus {
        Filed,
        UnderReview,
        CouncilReview,
        Rejected,
        ConfirmedViolation
    }

    struct Rule {
        uint256 id;
        ClarityRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct Review {
        uint256 id;
        address accuser;
        address accused;
        ReviewType reviewType;
        string details;
        ReviewStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => Review) public reviews;
    mapping(address => RoleType) public roles;
    mapping(address => bool) public councilMember;

    uint256 public councilCount;

    event RuleDeclared(uint256 indexed id, ClarityRule ruleType);
    event RuleLocked(uint256 indexed id);
    event ReviewFiled(uint256 indexed id, ReviewType reviewType);
    event ReviewStatusChanged(uint256 indexed id, ReviewStatus status);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        ruleCount = 0;
        reviewCount = 0;
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
            ClarityRule.ObjectiveSpecsRequired,
            "All procurement specifications must be objective, measurable, and testable."
        );
        _declareRule(
            ClarityRule.MultiVendorCompatibility,
            "Specs must allow multiple vendors unless technically impossible."
        );
        _declareRule(
            ClarityRule.TransparentCriteria,
            "Evaluation criteria must be published publicly before tender."
        );
        _declareRule(
            ClarityRule.PublicJustificationRequired,
            "Any single-vendor decision requires public justification."
        );
        _declareRule(
            ClarityRule.IndependentAuditRequired,
            "Independent audit required before any corruption allegation."
        );
        _declareRule(
            ClarityRule.NoRetroactiveRuleChange,
            "Procurement rules cannot be changed retroactively."
        );
        _declareRule(
            ClarityRule.NoSpecManipulation,
            "Specs cannot be manipulated to favor or harm any vendor."
        );
        _declareRule(
            ClarityRule.NoPoliticalInterference,
            "Political actors cannot interfere with procurement decisions."
        );
        _declareRule(
            ClarityRule.RiskContextRequired,
            "Risk context must be evaluated before any judgment."
        );
        _declareRule(
            ClarityRule.PublicBenefitRequired,
            "Public benefit must be considered in all procurement decisions."
        );
    }

    function _declareRule(ClarityRule ruleType, string memory description) internal {
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

    function fileReview(
        address accused,
        ReviewType reviewType,
        string calldata details
    ) external {
        reviewCount++;
        reviews[reviewCount] = Review(
            reviewCount,
            msg.sender,
            accused,
            reviewType,
            details,
            ReviewStatus.Filed,
            0,
            block.timestamp
        );

        emit ReviewFiled(reviewCount, reviewType);
    }

    function beginReview(uint256 reviewId) external onlyCouncil {
        Review storage r = reviews[reviewId];
        require(r.status == ReviewStatus.Filed, "Not filed");
        r.status = ReviewStatus.UnderReview;
        emit ReviewStatusChanged(reviewId, ReviewStatus.UnderReview);
    }

    function escalateToCouncil(uint256 reviewId) external onlyCouncil {
        Review storage r = reviews[reviewId];
        require(r.status == ReviewStatus.UnderReview, "Not under review");
        r.status = ReviewStatus.CouncilReview;
        emit ReviewStatusChanged(reviewId, ReviewStatus.CouncilReview);
    }

    function approveViolation(uint256 reviewId) external onlyCouncil {
        Review storage r = reviews[reviewId];
        require(r.status == ReviewStatus.CouncilReview, "Not in council stage");

        r.approvals++;

        if (r.approvals * 2 > councilCount && councilCount > 0) {
            r.status = ReviewStatus.ConfirmedViolation;
            emit ReviewStatusChanged(reviewId, ReviewStatus.ConfirmedViolation);
        }
    }

    function rejectReview(uint256 reviewId) external onlyCouncil {
        Review storage r
