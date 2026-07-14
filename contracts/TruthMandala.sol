// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Truth Mandala
/// @notice Encodes safeguard for systemic truth — the immutable axis of governance.
/// @dev Complements LeadershipAccountabilityMandala, TransparencyMandala, HumanityOracle, and InnovationConstitution.

contract TruthMandala {
    address public guardian;
    uint256 public mandalaCount;
    uint256 public councilCount;

    enum TruthRule {
        TruthIsConstitutional,
        EvidenceOverridesHierarchy,
        ReportsCannotBeSilenced,
        TransparencyMandated,
        PublicBenefitPriority
    }

    enum TruthStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        TruthConfirmed
    }

    struct Rule {
        uint256 id;
        TruthRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct TruthCase {
        uint256 id;
        address proposer;
        string grounds;
        TruthStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => TruthCase> public truthCases;
    mapping(address => bool> public councilMember;

    event RuleDeclared(uint256 indexed id, TruthRule ruleType);
    event RuleLocked(uint256 indexed id);
    event TruthFiled(uint256 indexed id);
    event TruthStatusChanged(uint256 indexed id, TruthStatus status);
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
        _declare(TruthRule.TruthIsConstitutional, "Truth is constitutional; denial prohibited.");
        _declare(TruthRule.EvidenceOverridesHierarchy, "Evidence overrides hierarchy; rank cannot silence truth.");
        _declare(TruthRule.ReportsCannotBeSilenced, "Reports cannot be silenced; findings must be preserved.");
        _declare(TruthRule.TransparencyMandated, "Truth systems must be auditable.");
        _declare(TruthRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
    }

    function _declare(TruthRule ruleType, string memory description) internal {
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

    function fileTruthCase(string calldata grounds) external {
        mandalaCount++;
        truthCases[mandalaCount] = TruthCase(
            mandalaCount,
            msg.sender,
            grounds,
            TruthStatus.Filed,
            0,
            block.timestamp
        );

        emit TruthFiled(mandalaCount);
    }

    function beginReview(uint256 truthId) external onlyCouncil {
        TruthCase storage t = truthCases[truthId];
        require(t.status == TruthStatus.Filed, "Not filed");
        t.status = TruthStatus.UnderReview;
        emit TruthStatusChanged(truthId, TruthStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 truthId) external onlyCouncil {
        TruthCase storage t = truthCases[truthId];
        require(t.status == TruthStatus.UnderReview, "Not under review");
        t.status = TruthStatus.MultiCouncilReview;
        emit TruthStatusChanged(truthId, TruthStatus.MultiCouncilReview);
    }

    function confirmTruth(uint256 truthId) external onlyCouncil {
        TruthCase storage t = truthCases[truthId];
        require(t.status == TruthStatus.MultiCouncilReview, "Not in council stage");

        t.approvals++;

        if (t.approvals * 2 > councilCount && councilCount > 0) {
            t.status = TruthStatus.TruthConfirmed;
            emit TruthStatusChanged(truthId, TruthStatus.TruthConfirmed);
        }
    }

    function rejectTruth(uint256 truthId) external onlyCouncil {
        TruthCase storage t = truthCases[truthId];
        require(
            t.status == TruthStatus.Filed ||
            t.status == TruthStatus.UnderReview ||
            t.status == TruthStatus.MultiCouncilReview,
            "Invalid status"
        );
        t.status = TruthStatus.Rejected;
        emit TruthStatusChanged(truthId, TruthStatus.Rejected);
    }
}
