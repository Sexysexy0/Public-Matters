// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Risk Context Review
/// @notice Encodes systemic risk assessment safeguard.
/// @dev Complements InnovationSafetyCovenant, DataOracle, and BureaucraticAccountability.

contract RiskContextReview {
    address public guardian;
    uint256 public reviewCount;
    uint256 public councilCount;

    enum RiskRule {
        RiskAssessmentIsConstitutional,
        ContextMandated,
        HazardSuppressed,
        TransparencyInRiskSystems,
        PublicBenefitPriority
    }

    enum RiskStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        RiskConfirmed
    }

    struct Rule {
        uint256 id;
        RiskRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct RiskCase {
        uint256 id;
        address proposer;
        string grounds;
        RiskStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => RiskCase) public riskCases;
    mapping(address => bool) public councilMember;

    event RuleDeclared(uint256 indexed id, RiskRule ruleType);
    event RuleLocked(uint256 indexed id);
    event RiskFiled(uint256 indexed id);
    event RiskStatusChanged(uint256 indexed id, RiskStatus status);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
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
        _declare(RiskRule.RiskAssessmentIsConstitutional, "Risk assessment is constitutional; denial prohibited.");
        _declare(RiskRule.ContextMandated, "Context mandated; hazard blocked.");
        _declare(RiskRule.HazardSuppressed, "Hazard suppressed; fairness required.");
        _declare(RiskRule.TransparencyInRiskSystems, "Risk systems must be transparent.");
        _declare(RiskRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
    }

    function _declare(RiskRule ruleType, string memory description) internal {
        reviewCount++;
        rules[reviewCount] = Rule(
            reviewCount,
            ruleType,
            description,
            false,
            block.timestamp
        );
        emit RuleDeclared(reviewCount, ruleType);
    }

    function lockRule(uint256 id) external onlyGuardian {
        Rule storage r = rules[id];
        require(!r.immutableEntry, "Already immutable");
        r.immutableEntry = true;
        emit RuleLocked(id);
    }

    function fileRiskCase(string calldata grounds) external {
        reviewCount++;
        riskCases[reviewCount] = RiskCase(
            reviewCount,
            msg.sender,
            grounds,
            RiskStatus.Filed,
            0,
            block.timestamp
        );

        emit RiskFiled(reviewCount);
    }

    function beginReview(uint256 riskId) external onlyCouncil {
        RiskCase storage r = riskCases[riskId];
        require(r.status == RiskStatus.Filed, "Not filed");
        r.status = RiskStatus.UnderReview;
        emit RiskStatusChanged(riskId, RiskStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 riskId) external onlyCouncil {
        RiskCase storage r = riskCases[riskId];
        require(r.status == RiskStatus.UnderReview, "Not under review");
        r.status = RiskStatus.MultiCouncilReview;
        emit RiskStatusChanged(riskId, RiskStatus.MultiCouncilReview);
    }

    function confirmRisk(uint256 riskId) external onlyCouncil {
        RiskCase storage r = riskCases[riskId];
        require(r.status == RiskStatus.MultiCouncilReview, "Not in council stage");

        r.approvals++;

        if (r.approvals * 2 > councilCount && councilCount > 0) {
            r.status = RiskStatus.RiskConfirmed;
            emit RiskStatusChanged(riskId, RiskStatus.RiskConfirmed);
        }
    }

    function rejectRisk(uint256 riskId) external onlyCouncil {
        RiskCase storage r = riskCases[riskId];
        require(
            r.status == RiskStatus.Filed ||
            r.status == RiskStatus.UnderReview ||
            r.status == RiskStatus.MultiCouncilReview,
            "Invalid status"
        );
        r.status = RiskStatus.Rejected;
        emit RiskStatusChanged(riskId, RiskStatus.Rejected);
    }
}
