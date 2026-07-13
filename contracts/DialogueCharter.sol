// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Dialogue Charter
/// @notice Encodes open dialogue, issue mapping, and CEO fix assertion.
/// @dev Complements IntegrityCharter, SolidarityMandala, and CooperationTreaty.

contract DialogueCharter {
    address public guardian;
    uint256 public charterCount;
    uint256 public issueCount;
    uint256 public councilCount;

    enum DialogueRule {
        DialogueIsConstitutional,
        OpenIssuesAnchored,
        GuardrailsRequired,
        KYCForCriticalSystems,
        CEOFixAssertionMandatory,
        PublicBenefitPriority,
        TransparencyInDialogueSystems
    }

    enum IssueType {
        GovernanceGap,
        AIModelRisk,
        DataAbuse,
        EmployeeConcern,
        RegulatoryNonCompliance,
        PublicBenefitFailure,
        TransparencyFailure
    }

    enum CaseStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        FixAsserted
    }

    struct Rule {
        uint256 id;
        DialogueRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct Issue {
        uint256 id;
        address reporter;
        address company;
        IssueType issueType;
        string details;
        CaseStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => Issue) public issues;
    mapping(address => bool) public councilMember;

    event RuleDeclared(uint256 indexed id, DialogueRule ruleType);
    event RuleLocked(uint256 indexed id);
    event IssueFiled(uint256 indexed id, IssueType issueType);
    event CaseStatusChanged(uint256 indexed id, CaseStatus status);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        charterCount = 0;
        issueCount = 0;
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
        _declare(DialogueRule.DialogueIsConstitutional, "Dialogue is constitutional; denial prohibited.");
        _declare(DialogueRule.OpenIssuesAnchored, "Open issues anchored; suppression prohibited.");
        _declare(DialogueRule.GuardrailsRequired, "Guardrails required for critical systems.");
        _declare(DialogueRule.KYCForCriticalSystems, "KYC required for powerful AI/data systems.");
        _declare(DialogueRule.CEOFixAssertionMandatory, "CEO must assert fixes for identified issues.");
        _declare(DialogueRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
        _declare(DialogueRule.TransparencyInDialogueSystems, "Dialogue systems must be transparent.");
    }

    function _declare(DialogueRule ruleType, string memory description) internal {
        charterCount++;
        rules[charterCount] = Rule(
            charterCount,
            ruleType,
            description,
            false,
            block.timestamp
        );
        emit RuleDeclared(charterCount, ruleType);
    }

    function lockRule(uint256 id) external onlyGuardian {
        Rule storage r = rules[id];
        require(!r.immutableEntry, "Already immutable");
        r.immutableEntry = true;
        emit RuleLocked(id);
    }

    function fileIssue(
        address company,
        IssueType issueType,
        string calldata details
    ) external {
        issueCount++;
        issues[issueCount] = Issue(
            issueCount,
            msg.sender,
            company,
            issueType,
            details,
            CaseStatus.Filed,
            0,
            block.timestamp
        );

        emit IssueFiled(issueCount, issueType);
    }

    function beginReview(uint256 issueId) external onlyCouncil {
        Issue storage i = issues[issueId];
        require(i.status == CaseStatus.Filed, "Not filed");
        i.status = CaseStatus.UnderReview;
        emit CaseStatusChanged(issueId, CaseStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 issueId) external onlyCouncil {
        Issue storage i = issues[issueId];
        require(i.status == CaseStatus.UnderReview, "Not under review");
        i.status = CaseStatus.MultiCouncilReview;
        emit CaseStatusChanged(issueId, CaseStatus.MultiCouncilReview);
    }

    function assertFix(uint256 issueId) external onlyCouncil {
        Issue storage i = issues[issueId];
        require(i.status == CaseStatus.MultiCouncilReview, "Not in council stage");

        i.approvals++;

        if (i.approvals * 2 > councilCount && councilCount > 0) {
            i.status = CaseStatus.FixAsserted;
            emit CaseStatusChanged(issueId, CaseStatus.FixAsserted);
        }
    }

    function rejectIssue(uint256 issueId) external onlyCouncil {
        Issue storage i = issues[issueId];
        require(
            i.status == CaseStatus.Filed ||
            i.status == CaseStatus.UnderReview ||
            i.status == CaseStatus.MultiCouncilReview,
            "Invalid status"
        );
        i.status = CaseStatus.Rejected;
        emit CaseStatusChanged(issueId, CaseStatus.Rejected);
    }
}
