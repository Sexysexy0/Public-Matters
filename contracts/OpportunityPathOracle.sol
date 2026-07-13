// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Opportunity Path Oracle
/// @notice Encodes safeguard for recognizing and formalizing new opportunities after systemic intervention.
/// @dev Complements IdentityRebuildMandala, VictimhoodExitCharter, and ResilienceShiftOracle.

contract OpportunityPathOracle {
    address public guardian;
    uint256 public oracleCount;
    uint256 public councilCount;

    enum OpportunityRule {
        OpportunityPathIsConstitutional,
        EmergenceMandated,
        SuppressionOfBlockages,
        TransparencyInOpportunitySystems,
        PublicBenefitPriority
    }

    enum OpportunityStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        OpportunityConfirmed
    }

    struct Rule {
        uint256 id;
        OpportunityRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct OpportunityCase {
        uint256 id;
        address proposer;
        string grounds;
        OpportunityStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => OpportunityCase) public opportunityCases;
    mapping(address => bool) public councilMember;

    event RuleDeclared(uint256 indexed id, OpportunityRule ruleType);
    event RuleLocked(uint256 indexed id);
    event OpportunityFiled(uint256 indexed id);
    event OpportunityStatusChanged(uint256 indexed id, OpportunityStatus status);
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
        _declare(OpportunityRule.OpportunityPathIsConstitutional, "Opportunity path is constitutional; denial prohibited.");
        _declare(OpportunityRule.EmergenceMandated, "Emergence mandated; blockages cleared.");
        _declare(OpportunityRule.SuppressionOfBlockages, "Blockages suppressed; fairness required.");
        _declare(OpportunityRule.TransparencyInOpportunitySystems, "Opportunity systems must be transparent.");
        _declare(OpportunityRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
    }

    function _declare(OpportunityRule ruleType, string memory description) internal {
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

    function fileOpportunityCase(string calldata grounds) external {
        oracleCount++;
        opportunityCases[oracleCount] = OpportunityCase(
            oracleCount,
            msg.sender,
            grounds,
            OpportunityStatus.Filed,
            0,
            block.timestamp
        );

        emit OpportunityFiled(oracleCount);
    }

    function beginReview(uint256 opportunityId) external onlyCouncil {
        OpportunityCase storage o = opportunityCases[opportunityId];
        require(o.status == OpportunityStatus.Filed, "Not filed");
        o.status = OpportunityStatus.UnderReview;
        emit OpportunityStatusChanged(opportunityId, OpportunityStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 opportunityId) external onlyCouncil {
        OpportunityCase storage o = opportunityCases[opportunityId];
        require(o.status == OpportunityStatus.UnderReview, "Not under review");
        o.status = OpportunityStatus.MultiCouncilReview;
        emit OpportunityStatusChanged(opportunityId, OpportunityStatus.MultiCouncilReview);
    }

    function confirmOpportunity(uint256 opportunityId) external onlyCouncil {
        OpportunityCase storage o = opportunityCases[opportunityId];
        require(o.status == OpportunityStatus.MultiCouncilReview, "Not in council stage");

        o.approvals++;

        if (o.approvals * 2 > councilCount && councilCount > 0) {
            o.status = OpportunityStatus.OpportunityConfirmed;
            emit OpportunityStatusChanged(opportunityId, OpportunityStatus.OpportunityConfirmed);
        }
    }

    function rejectOpportunity(uint256 opportunityId) external onlyCouncil {
        OpportunityCase storage o = opportunityCases[opportunityId];
        require(
            o.status == OpportunityStatus.Filed ||
            o.status == OpportunityStatus.UnderReview ||
            o.status == OpportunityStatus.MultiCouncilReview,
            "Invalid status"
        );
        o.status = OpportunityStatus.Rejected;
        emit OpportunityStatusChanged(opportunityId, OpportunityStatus.Rejected);
    }
}
