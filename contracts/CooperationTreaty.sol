// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Cooperation Treaty
/// @notice Unifies cooperation commitments into treaty law.
/// @dev Complements HonorMandala, HarmonyTreaty, and RaceFirewall.

contract CooperationTreaty {
    address public guardian;
    uint256 public treatyCount;
    uint256 public violationCount;
    uint256 public councilCount;

    enum CooperationRule {
        CooperationIsConstitutional,
        CollaborationAnchored,
        FragmentationProhibited,
        SolidaritySafeguarded,
        PublicBenefitPriority,
        MandatoryCouncilOversight,
        TransparencyInCooperationSystems
    }

    enum ViolationType {
        CooperationDenial,
        CollaborationFailure,
        Fragmentation,
        SolidarityBreach,
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
        CooperationRule ruleType;
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

    event RuleDeclared(uint256 indexed id, CooperationRule ruleType);
    event RuleLocked(uint256 indexed id);
    event ViolationFiled(uint256 indexed id, ViolationType violationType);
    event CaseStatusChanged(uint256 indexed id, CaseStatus status);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        treatyCount = 0;
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
        _declare(CooperationRule.CooperationIsConstitutional, "Cooperation is constitutional; denial prohibited.");
        _declare(CooperationRule.CollaborationAnchored, "Collaboration anchored; failure prohibited.");
        _declare(CooperationRule.FragmentationProhibited, "Fragmentation prohibited; violation blocked.");
        _declare(CooperationRule.SolidaritySafeguarded, "Solidarity safeguarded; breach prohibited.");
        _declare(CooperationRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
        _declare(CooperationRule.MandatoryCouncilOversight, "Council oversight required for cooperation enforcement.");
        _declare(CooperationRule.TransparencyInCooperationSystems, "Cooperation systems must be transparent.");
    }

    function _declare(CooperationRule ruleType, string memory description) internal {
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
