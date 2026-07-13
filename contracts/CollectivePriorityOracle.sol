// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Collective Priority Oracle
/// @notice Encodes safeguard for collective good — overrides individual exploitation.
/// @dev Complements PublicBenefitMandala, DataSovereigntyOracle, AIPrivacyMandala, and InnovationConstitution.

contract CollectivePriorityOracle {
    address public guardian;
    uint256 public oracleCount;
    uint256 public councilCount;

    enum PriorityRule {
        CollectiveGoodIsConstitutional,
        IndividualExploitationSuppressed,
        DormantSafeguardsActivated,
        TransparencyMandated,
        PublicBenefitPriority
    }

    enum PriorityStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        PriorityConfirmed
    }

    struct Rule {
        uint256 id;
        PriorityRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct PriorityCase {
        uint256 id;
        address proposer;
        string grounds;
        PriorityStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => PriorityCase) public priorityCases;
    mapping(address => bool) public councilMember;

    event RuleDeclared(uint256 indexed id, PriorityRule ruleType);
    event RuleLocked(uint256 indexed id);
    event PriorityFiled(uint256 indexed id);
    event PriorityStatusChanged(uint256 indexed id, PriorityStatus status);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        oracleCount = 0;
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
        _declare(PriorityRule.CollectiveGoodIsConstitutional, "Collective good is constitutional; denial prohibited.");
        _declare(PriorityRule.IndividualExploitationSuppressed, "Individual exploitation suppressed; fairness mandated.");
        _declare(PriorityRule.DormantSafeguardsActivated, "Dormant safeguards activated under systemic stress.");
        _declare(PriorityRule.TransparencyMandated, "Collective priority systems must be auditable.");
        _declare(PriorityRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
    }

    function _declare(PriorityRule ruleType, string memory description) internal {
        oracleCount++;
        rules[oracleCount] = Rule(
            oracleCount,
            ruleType,
            description,
            false,
            block.timestamp
        );
        emit RuleDeclared(oracleCount, ruleType);
    }

    function lockRule(uint256 id) external onlyGuardian {
        Rule storage r = rules[id];
        require(!r.immutableEntry, "Already immutable");
        r.immutableEntry = true;
        emit RuleLocked(id);
    }

    function filePriorityCase(string calldata grounds) external {
        oracleCount++;
        priorityCases[oracleCount] = PriorityCase(
            oracleCount,
            msg.sender,
            grounds,
            PriorityStatus.Filed,
            0,
            block.timestamp
        );

        emit PriorityFiled(oracleCount);
    }

    function beginReview(uint256 priorityId) external onlyCouncil {
        PriorityCase storage p = priorityCases[priorityId];
        require(p.status == PriorityStatus.Filed, "Not filed");
        p.status = PriorityStatus.UnderReview;
        emit PriorityStatusChanged(priorityId, PriorityStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 priorityId) external onlyCouncil {
        PriorityCase storage p = priorityCases[priorityId];
        require(p.status == PriorityStatus.UnderReview, "Not under review");
        p.status = PriorityStatus.MultiCouncilReview;
        emit PriorityStatusChanged(priorityId, PriorityStatus.MultiCouncilReview);
    }

    function confirmPriority(uint256 priorityId) external onlyCouncil {
        PriorityCase storage p = priorityCases[priorityId];
        require(p.status == PriorityStatus.MultiCouncilReview, "Not in council stage");

        p.approvals++;

        if (p.approvals * 2 > councilCount && councilCount > 0) {
            p.status = PriorityStatus.PriorityConfirmed;
            emit PriorityStatusChanged(priorityId, PriorityStatus.PriorityConfirmed);
        }
    }

    function rejectPriority(uint256 priorityId) external onlyCouncil {
        PriorityCase storage p = priorityCases[priorityId];
        require(
            p.status == PriorityStatus.Filed ||
            p.status == PriorityStatus.UnderReview ||
            p.status == PriorityStatus.MultiCouncilReview,
            "Invalid status"
        );
        p.status = PriorityStatus.Rejected;
        emit PriorityStatusChanged(priorityId, PriorityStatus.Rejected);
    }
}
