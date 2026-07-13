// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ICANN Contribution Mandala
/// @notice Encodes ICANN contribution safeguard.
/// @dev Complements ComplaintWithdrawalTreaty, RegistrarNoticeMandala, and RegistrarComplianceFramework.

contract ICANNContributionMandala {
    address public guardian;
    uint256 public contributionCount;
    uint256 public councilCount;

    enum ContributionRule {
        ContributionIsConstitutional,
        SubsidyRequired,
        SMEsAndNonProfitsSupported,
        TrainingFunded,
        PanelRemunerationEnabled,
        GuidanceMaterialsDeveloped,
        TransparencyInContributionSystems,
        PublicBenefitPriority
    }

    enum ContributionStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        ContributionConfirmed
    }

    struct Rule {
        uint256 id;
        ContributionRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct Contribution {
        uint256 id;
        address proposer;
        string grounds;
        ContributionStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => Contribution) public contributions;
    mapping(address => bool) public councilMember;

    event RuleDeclared(uint256 indexed id, ContributionRule ruleType);
    event RuleLocked(uint256 indexed id);
    event ContributionFiled(uint256 indexed id);
    event ContributionStatusChanged(uint256 indexed id, ContributionStatus status);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        contributionCount = 0;
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
        _declare(ContributionRule.ContributionIsConstitutional, "Contribution is constitutional; denial prohibited.");
        _declare(ContributionRule.SubsidyRequired, "Subsidy required; underfunding prohibited.");
        _declare(ContributionRule.SMEsAndNonProfitsSupported, "SMEs and non-profits supported; fairness required.");
        _declare(ContributionRule.TrainingFunded, "Training funded; ignorance prohibited.");
        _declare(ContributionRule.PanelRemunerationEnabled, "Panel remuneration enabled; exploitation blocked.");
        _declare(ContributionRule.GuidanceMaterialsDeveloped, "Guidance materials developed; clarity required.");
        _declare(ContributionRule.TransparencyInContributionSystems, "Contribution systems must be transparent.");
        _declare(ContributionRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
    }

    function _declare(ContributionRule ruleType, string memory description) internal {
        contributionCount++;
        rules[contributionCount] = Rule(
            contributionCount,
            ruleType,
            description,
            false,
            block.timestamp
        );
        emit RuleDeclared(contributionCount, ruleType);
    }

    function lockRule(uint256 id) external onlyGuardian {
        Rule storage r = rules[id];
        require(!r.immutableEntry, "Already immutable");
        r.immutableEntry = true;
        emit RuleLocked(id);
    }

    function fileContribution(string calldata grounds) external {
        contributionCount++;
        contributions[contributionCount] = Contribution(
            contributionCount,
            msg.sender,
            grounds,
            ContributionStatus.Filed,
            0,
            block.timestamp
        );

        emit ContributionFiled(contributionCount);
    }

    function beginReview(uint256 contributionId) external onlyCouncil {
        Contribution storage c = contributions[contributionId];
        require(c.status == ContributionStatus.Filed, "Not filed");
        c.status = ContributionStatus.UnderReview;
        emit ContributionStatusChanged(contributionId, ContributionStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 contributionId) external onlyCouncil {
        Contribution storage c = contributions[contributionId];
        require(c.status == ContributionStatus.UnderReview, "Not under review");
        c.status = ContributionStatus.MultiCouncilReview;
        emit ContributionStatusChanged(contributionId, ContributionStatus.MultiCouncilReview);
    }

    function confirmContribution(uint256 contributionId) external onlyCouncil {
        Contribution storage c = contributions[contributionId];
        require(c.status == ContributionStatus.MultiCouncilReview, "Not in council stage");

        c.approvals++;

        if (c.approvals * 2 > councilCount && councilCount > 0) {
            c.status = ContributionStatus.ContributionConfirmed;
            emit ContributionStatusChanged(contributionId, ContributionStatus.ContributionConfirmed);
        }
    }

    function rejectContribution(uint256 contributionId) external onlyCouncil {
        Contribution storage c = contributions[contributionId];
        require(
            c.status == ContributionStatus.Filed ||
            c.status == ContributionStatus.UnderReview ||
            c.status == ContributionStatus.MultiCouncilReview,
            "Invalid status"
        );
        c.status = ContributionStatus.Rejected;
        emit ContributionStatusChanged(contributionId, ContributionStatus.Rejected);
    }
}
