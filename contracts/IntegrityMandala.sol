// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Integrity Mandala
/// @notice Encodes safeguard for systemic integrity — binding force between truth, evidence, and accountability.
/// @dev Complements EvidenceChainOracle, TruthMandala, LeadershipAccountabilityMandala, and TransparencyMandala.

contract IntegrityMandala {
    address public guardian;
    uint256 public mandalaCount;
    uint256 public councilCount;

    enum IntegrityRule {
        IntegrityIsConstitutional,
        NoCorruptionDrift,
        TruthEvidenceAlignment,
        AccountabilityBinding,
        PublicBenefitPriority
    }

    enum IntegrityStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        IntegrityConfirmed
    }

    struct Rule {
        uint256 id;
        IntegrityRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct IntegrityCase {
        uint256 id;
        address proposer;
        string grounds;
        IntegrityStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule> public rules;
    mapping(uint256 => IntegrityCase> public integrityCases;
    mapping(address => bool> public councilMember;

    event RuleDeclared(uint256 indexed id, IntegrityRule ruleType);
    event RuleLocked(uint256 indexed id);
    event IntegrityFiled(uint256 indexed id);
    event IntegrityStatusChanged(uint256 indexed id, IntegrityStatus status);
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
        _declare(IntegrityRule.IntegrityIsConstitutional, "Integrity is constitutional; denial prohibited.");
        _declare(IntegrityRule.NoCorruptionDrift, "No corruption drift; systemic decay prevented.");
        _declare(IntegrityRule.TruthEvidenceAlignment, "Truth and evidence must remain aligned.");
        _declare(IntegrityRule.AccountabilityBinding, "Accountability binds leadership to truth.");
        _declare(IntegrityRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
    }

    function _declare(IntegrityRule ruleType, string memory description) internal {
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

    function fileIntegrityCase(string calldata grounds) external {
        mandalaCount++;
        integrityCases[mandalaCount] = IntegrityCase(
            mandalaCount,
            msg.sender,
            grounds,
            IntegrityStatus.Filed,
            0,
            block.timestamp
        );

        emit IntegrityFiled(mandalaCount);
    }

    function beginReview(uint256 integrityId) external onlyCouncil {
        IntegrityCase storage c = integrityCases[integrityId];
        require(c.status == IntegrityStatus.Filed, "Not filed");
        c.status = IntegrityStatus.UnderReview;
        emit IntegrityStatusChanged(integrityId, IntegrityStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 integrityId) external onlyCouncil {
        IntegrityCase storage c = integrityCases[integrityId];
        require(c.status == IntegrityStatus.UnderReview, "Not under review");
        c.status = IntegrityStatus.MultiCouncilReview;
        emit IntegrityStatusChanged(integrityId, IntegrityStatus.MultiCouncilReview);
    }

    function confirmIntegrity(uint256 integrityId) external onlyCouncil {
        IntegrityCase storage c = integrityCases[integrityId];
        require(c.status == IntegrityStatus.MultiCouncilReview, "Not in council stage");

        c.approvals++;

        if (c.approvals * 2 > councilCount && councilCount > 0) {
            c.status = IntegrityStatus.IntegrityConfirmed;
            emit IntegrityStatusChanged(integrityId, IntegrityStatus.IntegrityConfirmed);
        }
    }

    function rejectIntegrity(uint256 integrityId) external onlyCouncil {
        IntegrityCase storage c = integrityCases[integrityId];
        require(
            c.status == IntegrityStatus.Filed ||
            c.status == IntegrityStatus.UnderReview ||
            c.status == IntegrityStatus.MultiCouncilReview,
            "Invalid status"
        );
        c.status = IntegrityStatus.Rejected;
        emit IntegrityStatusChanged(integrityId, IntegrityStatus.Rejected);
    }
}
