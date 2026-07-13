// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Justice Oversight Covenant
/// @notice Provides judicial oversight for loyalty, defense, and war covenants.
/// @dev Complements CitizenLoyaltyCharter, DefenseTransparency, WarPowersTransparency, and NationalSecurityCovenant.

contract JusticeOversightCovenant {
    address public guardian;
    uint256 public oversightCount;
    uint256 public violationCount;
    uint256 public justiceCount;

    enum OversightRule {
        MandatoryJudicialReview,
        NoCouncilMonopoly,
        TransparencyInJudicialDecisions,
        PublicBenefitPriority,
        JudicialIntegrityIsConstitutional
    }

    enum ViolationType {
        CouncilMonopoly,
        JudicialBypass,
        TransparencyFailure,
        PublicBenefitErasure,
        ConstitutionalDisrespect
    }

    enum CaseStatus {
        Filed,
        UnderReview,
        MultiJusticeReview,
        Rejected,
        ConfirmedViolation
    }

    struct Rule {
        uint256 id;
        OversightRule ruleType;
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
    mapping(address => bool) public justiceMember;

    event RuleDeclared(uint256 indexed id, OversightRule ruleType);
    event RuleLocked(uint256 indexed id);
    event ViolationFiled(uint256 indexed id, ViolationType violationType);
    event CaseStatusChanged(uint256 indexed id, CaseStatus status);
    event JusticeMemberAdded(address indexed member);
    event JusticeMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        oversightCount = 0;
        violationCount = 0;
        justiceCount = 0;

        _declareDefaultRules();
    }

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Guardian only");
        _;
    }

    modifier onlyJustice() {
        require(justiceMember[msg.sender], "Justice only");
        _;
    }

    function addJusticeMember(address member) external onlyGuardian {
        require(!justiceMember[member], "Already justice");
        justiceMember[member] = true;
        justiceCount++;
        emit JusticeMemberAdded(member);
    }

    function removeJusticeMember(address member) external onlyGuardian {
        require(justiceMember[member], "Not justice");
        justiceMember[member] = false;
        justiceCount--;
        emit JusticeMemberRemoved(member);
    }

    function _declareDefaultRules() internal {
        _declare(OversightRule.MandatoryJudicialReview, "All loyalty, defense, and war covenants require judicial review.");
        _declare(OversightRule.NoCouncilMonopoly, "Council cannot monopolize oversight without judicial check.");
        _declare(OversightRule.TransparencyInJudicialDecisions, "Judicial decisions must be transparent.");
        _declare(OversightRule.PublicBenefitPriority, "Public benefit overrides political or elite gain.");
        _declare(OversightRule.JudicialIntegrityIsConstitutional, "Judicial integrity is constitutional.");
    }

    function _declare(OversightRule ruleType, string memory description) internal {
        oversightCount++;
        rules[oversightCount] = Rule(
            oversightCount,
            ruleType,
            description,
            false,
            block.timestamp
        );
        emit RuleDeclared(oversightCount, ruleType);
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

    function beginReview(uint256 violationId) external onlyJustice {
        Violation storage v = violations[violationId];
        require(v.status == CaseStatus.Filed, "Not filed");
        v.status = CaseStatus.UnderReview;
        emit CaseStatusChanged(violationId, CaseStatus.UnderReview);
    }

    function escalateToMultiJustice(uint256 violationId) external onlyJustice {
        Violation storage v = violations[violationId];
        require(v.status == CaseStatus.UnderReview, "Not under review");
        v.status = CaseStatus.MultiJusticeReview;
        emit CaseStatusChanged(violationId, CaseStatus.MultiJusticeReview);
    }

    function approveViolation(uint256 violationId) external onlyJustice {
        Violation storage v = violations[violationId];
        require(v.status == CaseStatus.MultiJusticeReview, "Not in justice stage");

        v.approvals++;

        if (v.approvals * 2 > justiceCount && justiceCount > 0) {
            v.status = CaseStatus.ConfirmedViolation;
            emit CaseStatusChanged(violationId, CaseStatus.ConfirmedViolation);
        }
    }

    function rejectViolation(uint256 violationId) external onlyJustice {
        Violation storage v = violations[violationId];
        require(
            v.status == CaseStatus.Filed ||
            v.status == CaseStatus.UnderReview ||
            v.status == CaseStatus.MultiJusticeReview,
            "Invalid status"
        );
        v.status = CaseStatus.Rejected;
        emit CaseStatusChanged(violationId, CaseStatus.Rejected);
    }
}
