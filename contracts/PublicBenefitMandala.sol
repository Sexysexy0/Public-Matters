// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Public Benefit Mandala
/// @notice Encodes safeguard for systemic public benefit — anchor across all oracles.
/// @dev Complements DataSovereigntyOracle, AIPrivacyMandala, InnovationConstitution, and DormantCodeOracle.

contract PublicBenefitMandala {
    address public guardian;
    uint256 public mandalaCount;
    uint256 public councilCount;

    enum BenefitRule {
        PublicBenefitIsConstitutional,
        EliteGainSuppressed,
        CollectivePriorityMandated,
        TransparencyMandated,
        DormantSafeguardsActivated
    }

    enum BenefitStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        BenefitConfirmed
    }

    struct Rule {
        uint256 id;
        BenefitRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct BenefitCase {
        uint256 id;
        address proposer;
        string grounds;
        BenefitStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => BenefitCase) public benefitCases;
    mapping(address => bool) public councilMember;

    event RuleDeclared(uint256 indexed id, BenefitRule ruleType);
    event RuleLocked(uint256 indexed id);
    event BenefitFiled(uint256 indexed id);
    event BenefitStatusChanged(uint256 indexed id, BenefitStatus status);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        mandalaCount = 0;
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
        _declare(BenefitRule.PublicBenefitIsConstitutional, "Public benefit is constitutional; denial prohibited.");
        _declare(BenefitRule.EliteGainSuppressed, "Elite gain suppressed; collective fairness mandated.");
        _declare(BenefitRule.CollectivePriorityMandated, "Collective priority mandated; masa protected.");
        _declare(BenefitRule.TransparencyMandated, "Public benefit systems must be auditable.");
        _declare(BenefitRule.DormantSafeguardsActivated, "Dormant safeguards activated under systemic stress.");
    }

    function _declare(BenefitRule ruleType, string memory description) internal {
        mandalaCount++;
        rules[mandalaCount] = Rule(
            mandalaCount,
            ruleType,
            description,
            false,
            block.timestamp
        );
        emit RuleDeclared(mandalaCount, ruleType);
    }

    function lockRule(uint256 id) external onlyGuardian {
        Rule storage r = rules[id];
        require(!r.immutableEntry, "Already immutable");
        r.immutableEntry = true;
        emit RuleLocked(id);
    }

    function fileBenefitCase(string calldata grounds) external {
        mandalaCount++;
        benefitCases[mandalaCount] = BenefitCase(
            mandalaCount,
            msg.sender,
            grounds,
            BenefitStatus.Filed,
            0,
            block.timestamp
        );

        emit BenefitFiled(mandalaCount);
    }

    function beginReview(uint256 benefitId) external onlyCouncil {
        BenefitCase storage b = benefitCases[benefitId];
        require(b.status == BenefitStatus.Filed, "Not filed");
        b.status = BenefitStatus.UnderReview;
        emit BenefitStatusChanged(benefitId, BenefitStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 benefitId) external onlyCouncil {
        BenefitCase storage b = benefitCases[benefitId];
        require(b.status == BenefitStatus.UnderReview, "Not under review");
        b.status = BenefitStatus.MultiCouncilReview;
        emit BenefitStatusChanged(benefitId, BenefitStatus.MultiCouncilReview);
    }

    function confirmBenefit(uint256 benefitId) external onlyCouncil {
        BenefitCase storage b = benefitCases[benefitId];
        require(b.status == BenefitStatus.MultiCouncilReview, "Not in council stage");

        b.approvals++;

        if (b.approvals * 2 > councilCount && councilCount > 0) {
            b.status = BenefitStatus.BenefitConfirmed;
            emit BenefitStatusChanged(benefitId, BenefitStatus.BenefitConfirmed);
        }
    }

    function rejectBenefit(uint256 benefitId) external onlyCouncil {
        BenefitCase storage b = benefitCases[benefitId];
        require(
            b.status == BenefitStatus.Filed ||
            b.status == BenefitStatus.UnderReview ||
            b.status == BenefitStatus.MultiCouncilReview,
            "Invalid status"
        );
        b.status = BenefitStatus.Rejected;
        emit BenefitStatusChanged(benefitId, BenefitStatus.Rejected);
    }
}
