// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Bethesda Soul Charter
/// @notice Restores soul and creative dignity of the studio.
/// @dev Encodes cultural reset, talent revival, player feedback covenant, and innovation freedom.

contract BethesdaSoulCharter {
    address public guardian;
    uint256 public charterCount;
    uint256 public violationCount;
    uint256 public councilCount;

    enum SoulRule {
        SoulIsConstitutional,
        CulturalResetAnchored,
        TalentRevivalProtected,
        PlayerFeedbackSafeguarded,
        InnovationFreedomPriority,
        PublicBenefitPriority,
        MandatoryCouncilOversight,
        TransparencyInSoulSystems
    }

    enum ViolationType {
        SoulDenial,
        CulturalSuppression,
        TalentNeglect,
        PlayerFeedbackIgnored,
        InnovationBlocked,
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
        SoulRule ruleType;
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
    mapping(address => bool) public councilMember;

    event RuleDeclared(uint256 indexed id, SoulRule ruleType);
    event RuleLocked(uint256 indexed id);
    event ViolationFiled(uint256 indexed id, ViolationType violationType);
    event CaseStatusChanged(uint256 indexed id, CaseStatus status);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        charterCount = 0;
        violationCount = 0;
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
        _declare(SoulRule.SoulIsConstitutional, "Soul is constitutional; denial prohibited.");
        _declare(SoulRule.CulturalResetAnchored, "Cultural reset is anchored; suppression prohibited.");
        _declare(SoulRule.TalentRevivalProtected, "Talent revival protected; neglect prohibited.");
        _declare(SoulRule.PlayerFeedbackSafeguarded, "Player feedback safeguarded; ignoring prohibited.");
        _declare(SoulRule.InnovationFreedomPriority, "Innovation freedom prioritized over stagnation.");
        _declare(SoulRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
        _declare(SoulRule.MandatoryCouncilOversight, "Council oversight required for soul enforcement.");
        _declare(SoulRule.TransparencyInSoulSystems, "Soul systems must be transparent.");
    }

    function _declare(SoulRule ruleType, string memory description) internal {
        charterCount++;
        rules[charterCount] = Rule(
            charterCount,
            ruleType,
            description,
            false,
            block.timestamp
        );
        emit RuleDeclared(charterCount, ruleType);
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

    function beginReview(uint256 violationId) external onlyCouncil {
        Violation storage v = violations[violationId];
        require(v.status == CaseStatus.Filed, "Not filed");
        v.status = CaseStatus.UnderReview;
        emit CaseStatusChanged(violationId, CaseStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 violationId) external onlyCouncil {
        Violation storage v = violations[violationId];
        require(v.status == CaseStatus.UnderReview, "Not under review");
        v.status = CaseStatus.MultiCouncilReview;
        emit CaseStatusChanged(violationId, CaseStatus.MultiCouncilReview);
    }

    function approveViolation(uint256 violationId) external onlyCouncil {
        Violation storage v = violations[violationId];
        require(v.status == CaseStatus.MultiCouncilReview, "Not in council stage");

        v.approvals++;

        if (v.approvals * 2 > councilCount && councilCount > 0) {
            v.status = CaseStatus.ConfirmedViolation;
            emit CaseStatusChanged(violationId, CaseStatus.ConfirmedViolation);
        }
    }

    function rejectViolation(uint256 violationId) external onlyCouncil {
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
