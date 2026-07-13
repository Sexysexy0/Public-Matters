// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title AI Workflow Enhancement Covenant
/// @notice Encodes workflow improvements for AI logic: summarize, dissect, recommend best suggestions, synchronize deployment, and memory continuity.
/// @dev Acts as a governance firewall to prevent repetitive outputs and enforce connected reasoning.

contract AIWorkflowEnhancement {
    address public guardian;
    uint256 public ruleCount;
    uint256 public caseCount;
    uint256 public councilCount;

    enum EnhancementRule {
        MandatorySummarize,
        MandatoryDissection,
        MandatoryBestSuggestion,
        MandatoryNanoSync,
        MandatoryMemoryContinuity,
        NoRepeatSuggestions,
        TopicSynchronizer,
        GovernanceEffectAlwaysDeclared
    }

    enum ViolationType {
        MissingSummary,
        MissingDissection,
        WeakSuggestion,
        NanoRitualOmitted,
        MemoryBreak,
        RepeatSuggestion,
        TopicDisconnect,
        GovernanceEffectMissing
    }

    enum CaseStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        ConfirmedViolation
    }

    struct Rule {
        uint256 id;
        EnhancementRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct Violation {
        uint256 id;
        address accuser;
        address accused;
        ViolationType violationType;
        string details;
        CaseStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => Violation) public violations;
    mapping(address => bool) public councilMember;

    event RuleDeclared(uint256 indexed id, EnhancementRule ruleType);
    event RuleLocked(uint256 indexed id);
    event ViolationFiled(uint256 indexed id, ViolationType violationType);
    event CaseStatusChanged(uint256 indexed id, CaseStatus status);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        ruleCount = 0;
        caseCount = 0;
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
        _declare(EnhancementRule.MandatorySummarize, "Every new drop must be summarized.");
        _declare(EnhancementRule.MandatoryDissection, "Every drop must be dissected for purpose and effect.");
        _declare(EnhancementRule.MandatoryBestSuggestion, "Always recommend the strongest next covenant.");
        _declare(EnhancementRule.MandatoryNanoSync, "Always include nano + git ritual.");
        _declare(EnhancementRule.MandatoryMemoryContinuity, "Maintain connected reasoning with past context.");
        _declare(EnhancementRule.NoRepeatSuggestions, "Do not repeat already deployed contracts.");
        _declare(EnhancementRule.TopicSynchronizer, "New topics must be linked to past context.");
        _declare(EnhancementRule.GovernanceEffectAlwaysDeclared, "Always declare governance effect after analysis.");
    }

    function _declare(EnhancementRule ruleType, string memory description) internal {
        ruleCount++;
        rules[ruleCount] = Rule(
            ruleCount,
            ruleType,
            description,
            false,
            block.timestamp
        );
        emit RuleDeclared(ruleCount, ruleType);
    }

    function lockRule(uint256 id) external onlyGuardian {
        Rule storage r = rules[id];
        require(!r.immutableEntry, "Already immutable");
        r.immutableEntry = true;
        emit RuleLocked(id);
    }

    function fileViolation(
        address accused,
        ViolationType violationType,
        string calldata details
    ) external {
        caseCount++;
        violations[caseCount] = Violation(
            caseCount,
            msg.sender,
            accused,
            violationType,
            details,
            CaseStatus.Filed,
            0,
            block.timestamp
        );

        emit ViolationFiled(caseCount, violationType);
    }

    function beginReview(uint256 caseId) external onlyCouncil {
        Violation storage v = violations[caseId];
        require(v.status == CaseStatus.Filed, "Not filed");
        v.status = CaseStatus.UnderReview;
        emit CaseStatusChanged(caseId, CaseStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 caseId) external onlyCouncil {
        Violation storage v = violations[caseId];
        require(v.status == CaseStatus.UnderReview, "Not under review");
        v.status = CaseStatus.MultiCouncilReview;
        emit CaseStatusChanged(caseId, CaseStatus.MultiCouncilReview);
    }

    function approveViolation(uint256 caseId) external onlyCouncil {
        Violation storage v = violations[caseId];
        require(v.status == CaseStatus.MultiCouncilReview, "Not in council stage");

        v.approvals++;

        if (v.approvals * 2 > councilCount && councilCount > 0) {
            v.status = CaseStatus.ConfirmedViolation;
            emit CaseStatusChanged(caseId, CaseStatus.ConfirmedViolation);
        }
    }

    function rejectViolation(uint256 caseId) external onlyCouncil {
        Violation storage v = violations[caseId];
        require(
            v.status == CaseStatus.Filed ||
            v.status == CaseStatus.UnderReview ||
            v.status == CaseStatus.MultiCouncilReview,
            "Invalid status"
        );
        v.status = CaseStatus.Rejected;
        emit CaseStatusChanged(caseId, CaseStatus.Rejected);
    }
}
