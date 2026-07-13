// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Leadership Orchestration Mandala
/// @notice Encodes orchestration safeguard for expanding tech C-suite.
/// @dev Complements InnovationMeritShield, BureaucraticAccountability, and PublicBenefitOracle.

contract LeadershipOrchestrationMandala {
    address public guardian;
    uint256 public mandalaCount;
    uint256 public councilCount;

    enum OrchestrationRule {
        OrchestrationIsConstitutional,
        AlignmentMandated,
        FragmentationSuppressed,
        TransparencyInLeadershipSystems,
        PublicBenefitPriority
    }

    enum OrchestrationStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        OrchestrationConfirmed
    }

    struct Rule {
        uint256 id;
        OrchestrationRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct OrchestrationCase {
        uint256 id;
        address proposer;
        string grounds;
        OrchestrationStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => OrchestrationCase) public orchestrationCases;
    mapping(address => bool) public councilMember;

    event RuleDeclared(uint256 indexed id, OrchestrationRule ruleType);
    event RuleLocked(uint256 indexed id);
    event OrchestrationFiled(uint256 indexed id);
    event OrchestrationStatusChanged(uint256 indexed id, OrchestrationStatus status);
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
        _declare(OrchestrationRule.OrchestrationIsConstitutional, "Orchestration is constitutional; denial prohibited.");
        _declare(OrchestrationRule.AlignmentMandated, "Alignment mandated; fragmentation blocked.");
        _declare(OrchestrationRule.FragmentationSuppressed, "Fragmentation suppressed; fairness required.");
        _declare(OrchestrationRule.TransparencyInLeadershipSystems, "Leadership systems must be transparent.");
        _declare(OrchestrationRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
    }

    function _declare(OrchestrationRule ruleType, string memory description) internal {
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

    function fileOrchestrationCase(string calldata grounds) external {
        mandalaCount++;
        orchestrationCases[mandalaCount] = OrchestrationCase(
            mandalaCount,
            msg.sender,
            grounds,
            OrchestrationStatus.Filed,
            0,
            block.timestamp
        );

        emit OrchestrationFiled(mandalaCount);
    }

    function beginReview(uint256 orchestrationId) external onlyCouncil {
        OrchestrationCase storage o = orchestrationCases[orchestrationId];
        require(o.status == OrchestrationStatus.Filed, "Not filed");
        o.status = OrchestrationStatus.UnderReview;
        emit OrchestrationStatusChanged(orchestrationId, OrchestrationStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 orchestrationId) external onlyCouncil {
        OrchestrationCase storage o = orchestrationCases[orchestrationId];
        require(o.status == OrchestrationStatus.UnderReview, "Not under review");
        o.status = OrchestrationStatus.MultiCouncilReview;
        emit OrchestrationStatusChanged(orchestrationId, OrchestrationStatus.MultiCouncilReview);
    }

    function confirmOrchestration(uint256 orchestrationId) external onlyCouncil {
        OrchestrationCase storage o = orchestrationCases[orchestrationId];
        require(o.status == OrchestrationStatus.MultiCouncilReview, "Not in council stage");

        o.approvals++;

        if (o.approvals * 2 > councilCount && councilCount > 0) {
            o.status = OrchestrationStatus.OrchestrationConfirmed;
            emit OrchestrationStatusChanged(orchestrationId, OrchestrationStatus.OrchestrationConfirmed);
        }
    }

    function rejectOrchestration(uint256 orchestrationId) external onlyCouncil {
        OrchestrationCase storage o = orchestrationCases[orchestrationId];
        require(
            o.status == OrchestrationStatus.Filed ||
            o.status == OrchestrationStatus.UnderReview ||
            o.status == OrchestrationStatus.MultiCouncilReview,
            "Invalid status"
        );
        o.status = OrchestrationStatus.Rejected;
        emit OrchestrationStatusChanged(orchestrationId, OrchestrationStatus.Rejected);
    }
}
