// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Dignity Mandala
/// @notice Encodes safeguard for systemic dignity — non-negotiable covenant across all systems.
/// @dev Complements HumanityOracle, StrangersMandala, TransparencyMandala, and PublicBenefitMandala.

contract DignityMandala {
    address public guardian;
    uint256 public mandalaCount;
    uint256 public councilCount;

    enum DignityRule {
        DignityIsConstitutional,
        HumanityMandated,
        StrangersProtected,
        AbuseReboundsOnAbuser,
        CollectivePriorityAnchored
    }

    enum DignityStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        DignityConfirmed
    }

    struct Rule {
        uint256 id;
        DignityRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct DignityCase {
        uint256 id;
        address proposer;
        string grounds;
        DignityStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => DignityCase) public dignityCases;
    mapping(address => bool) public councilMember;

    event RuleDeclared(uint256 indexed id, DignityRule ruleType);
    event RuleLocked(uint256 indexed id);
    event DignityFiled(uint256 indexed id);
    event DignityStatusChanged(uint256 indexed id, DignityStatus status);
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
        _declare(DignityRule.DignityIsConstitutional, "Dignity is constitutional; denial prohibited.");
        _declare(DignityRule.HumanityMandated, "Humanity mandated; systemic fairness enforced.");
        _declare(DignityRule.StrangersProtected, "Strangers protected; dignity extended to outsiders.");
        _declare(DignityRule.AbuseReboundsOnAbuser, "Abuse rebounds on abuser; violence cycles back.");
        _declare(DignityRule.CollectivePriorityAnchored, "Collective priority anchored; masa protected.");
    }

    function _declare(DignityRule ruleType, string memory description) internal {
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

    function fileDignityCase(string calldata grounds) external {
        mandalaCount++;
        dignityCases[mandalaCount] = DignityCase(
            mandalaCount,
            msg.sender,
            grounds,
            DignityStatus.Filed,
            0,
            block.timestamp
        );

        emit DignityFiled(mandalaCount);
    }

    function beginReview(uint256 dignityId) external onlyCouncil {
        DignityCase storage d = dignityCases[dignityId];
        require(d.status == DignityStatus.Filed, "Not filed");
        d.status = DignityStatus.UnderReview;
        emit DignityStatusChanged(dignityId, DignityStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 dignityId) external onlyCouncil {
        DignityCase storage d = dignityCases[dignityId];
        require(d.status == DignityStatus.UnderReview, "Not under review");
        d.status = DignityStatus.MultiCouncilReview;
        emit DignityStatusChanged(dignityId, DignityStatus.MultiCouncilReview);
    }

    function confirmDignity(uint256 dignityId) external onlyCouncil {
        DignityCase storage d = dignityCases[dignityId];
        require(d.status == DignityStatus.MultiCouncilReview, "Not in council stage");

        d.approvals++;

        if (d.approvals * 2 > councilCount && councilCount > 0) {
            d.status = DignityStatus.DignityConfirmed;
            emit DignityStatusChanged(dignityId, DignityStatus.DignityConfirmed);
        }
    }

    function rejectDignity(uint256 dignityId) external onlyCouncil {
        DignityCase storage d = dignityCases[dignityId];
        require(
            d.status == DignityStatus.Filed ||
            d.status == DignityStatus.UnderReview ||
            d.status == DignityStatus.MultiCouncilReview,
            "Invalid status"
        );
        d.status = DignityStatus.Rejected;
        emit DignityStatusChanged(dignityId, DignityStatus.Rejected);
    }
}
