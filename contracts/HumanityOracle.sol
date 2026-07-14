// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Humanity Oracle
/// @notice Encodes safeguard for systemic humanity — ultimate covenant anchor.
/// @dev Complements StrangersMandala, TransparencyMandala, PublicBenefitMandala, and InnovationConstitution.

contract HumanityOracle {
    address public guardian;
    uint256 public oracleCount;
    uint256 public councilCount;

    enum HumanityRule {
        HumanityIsConstitutional,
        DignityMandated,
        StrangersProtected,
        AbuseReboundsOnAbuser,
        CollectivePriorityAnchored
    }

    enum HumanityStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        HumanityConfirmed
    }

    struct Rule {
        uint256 id;
        HumanityRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct HumanityCase {
        uint256 id;
        address proposer;
        string grounds;
        HumanityStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => HumanityCase) public humanityCases;
    mapping(address => bool) public councilMember;

    event RuleDeclared(uint256 indexed id, HumanityRule ruleType);
    event RuleLocked(uint256 indexed id);
    event HumanityFiled(uint256 indexed id);
    event HumanityStatusChanged(uint256 indexed id, HumanityStatus status);
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
        _declare(HumanityRule.HumanityIsConstitutional, "Humanity is constitutional; denial prohibited.");
        _declare(HumanityRule.DignityMandated, "Dignity mandated; systemic fairness enforced.");
        _declare(HumanityRule.StrangersProtected, "Strangers protected; dignity extended to outsiders.");
        _declare(HumanityRule.AbuseReboundsOnAbuser, "Abuse rebounds on abuser; violence cycles back.");
        _declare(HumanityRule.CollectivePriorityAnchored, "Collective priority anchored; masa protected.");
    }

    function _declare(HumanityRule ruleType, string memory description) internal {
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

    function fileHumanityCase(string calldata grounds) external {
        oracleCount++;
        humanityCases[oracleCount] = HumanityCase(
            oracleCount,
            msg.sender,
            grounds,
            HumanityStatus.Filed,
            0,
            block.timestamp
        );

        emit HumanityFiled(oracleCount);
    }

    function beginReview(uint256 humanityId) external onlyCouncil {
        HumanityCase storage h = humanityCases[humanityId];
        require(h.status == HumanityStatus.Filed, "Not filed");
        h.status = HumanityStatus.UnderReview;
        emit HumanityStatusChanged(humanityId, HumanityStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 humanityId) external onlyCouncil {
        HumanityCase storage h = humanityCases[humanityId];
        require(h.status == HumanityStatus.UnderReview, "Not under review");
        h.status = HumanityStatus.MultiCouncilReview;
        emit HumanityStatusChanged(humanityId, HumanityStatus.MultiCouncilReview);
    }

    function confirmHumanity(uint256 humanityId) external onlyCouncil {
        HumanityCase storage h = humanityCases[humanityId];
        require(h.status == HumanityStatus.MultiCouncilReview, "Not in council stage");

        h.approvals++;

        if (h.approvals * 2 > councilCount && councilCount > 0) {
            h.status = HumanityStatus.HumanityConfirmed;
            emit HumanityStatusChanged(humanityId, HumanityStatus.HumanityConfirmed);
        }
    }

    function rejectHumanity(uint256 humanityId) external onlyCouncil {
        HumanityCase storage h = humanityCases[humanityId];
        require(
            h.status == HumanityStatus.Filed ||
            h.status == HumanityStatus.UnderReview ||
            h.status == HumanityStatus.MultiCouncilReview,
            "Invalid status"
        );
        h.status = HumanityStatus.Rejected;
        emit HumanityStatusChanged(humanityId, HumanityStatus.Rejected);
    }
}
