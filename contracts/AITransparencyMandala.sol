// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title AI Transparency Mandala
/// @notice Encodes transparency and repeatability safeguard for AI systems.
/// @dev Complements DataOracle, InnovationSafetyCovenant, and BureaucraticAccountability.

contract AITransparencyMandala {
    address public guardian;
    uint256 public mandalaCount;
    uint256 public councilCount;

    enum AIRule {
        TransparencyIsConstitutional,
        RepeatabilityMandated,
        BiasSuppressed,
        AccountabilityInAISystems,
        PublicBenefitPriority
    }

    enum AIStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        AIConfirmed
    }

    struct Rule {
        uint256 id;
        AIRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct AICase {
        uint256 id;
        address proposer;
        string grounds;
        AIStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => AICase) public aiCases;
    mapping(address => bool) public councilMember;

    event RuleDeclared(uint256 indexed id, AIRule ruleType);
    event RuleLocked(uint256 indexed id);
    event AIFiled(uint256 indexed id);
    event AIStatusChanged(uint256 indexed id, AIStatus status);
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
        _declare(AIRule.TransparencyIsConstitutional, "Transparency is constitutional; denial prohibited.");
        _declare(AIRule.RepeatabilityMandated, "Repeatability mandated; bias blocked.");
        _declare(AIRule.BiasSuppressed, "Bias suppressed; fairness required.");
        _declare(AIRule.AccountabilityInAISystems, "AI systems must be accountable.");
        _declare(AIRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
    }

    function _declare(AIRule ruleType, string memory description) internal {
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

    function fileAICase(string calldata grounds) external {
        mandalaCount++;
        aiCases[mandalaCount] = AICase(
            mandalaCount,
            msg.sender,
            grounds,
            AIStatus.Filed,
            0,
            block.timestamp
        );

        emit AIFiled(mandalaCount);
    }

    function beginReview(uint256 aiId) external onlyCouncil {
        AICase storage a = aiCases[aiId];
        require(a.status == AIStatus.Filed, "Not filed");
        a.status = AIStatus.UnderReview;
        emit AIStatusChanged(aiId, AIStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 aiId) external onlyCouncil {
        AICase storage a = aiCases[aiId];
        require(a.status == AIStatus.UnderReview, "Not under review");
        a.status = AIStatus.MultiCouncilReview;
        emit AIStatusChanged(aiId, AIStatus.MultiCouncilReview);
    }

    function confirmAI(uint256 aiId) external onlyCouncil {
        AICase storage a = aiCases[aiId];
        require(a.status == AIStatus.MultiCouncilReview, "Not in council stage");

        a.approvals++;

        if (a.approvals * 2 > councilCount && councilCount > 0) {
            a.status = AIStatus.AIConfirmed;
            emit AIStatusChanged(aiId, AIStatus.AIConfirmed);
        }
    }

    function rejectAI(uint256 aiId) external onlyCouncil {
        AICase storage a = aiCases[aiId];
        require(
            a.status == AIStatus.Filed ||
            a.status == AIStatus.UnderReview ||
            a.status == AIStatus.MultiCouncilReview,
            "Invalid status"
        );
        a.status = AIStatus.Rejected;
        emit AIStatusChanged(aiId, AIStatus.Rejected);
    }
}
