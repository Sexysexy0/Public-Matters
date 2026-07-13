// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Vision Charter
/// @notice Encodes personal narrative and ethical responsibility.
/// @dev Complements DialogueCharter, ResponsibilityMandala, and TruthTreaty.

contract VisionCharter {
    address public guardian;
    uint256 public charterCount;
    uint256 public narrativeCount;
    uint256 public councilCount;

    enum VisionRule {
        NarrativeIsConstitutional,
        EthicalResponsibilityAnchored,
        ChaosProhibited,
        PawnhoodBlocked,
        OpportunityInResponsibility,
        PublicBenefitPriority,
        TransparencyInVisionSystems
    }

    enum NarrativeType {
        PersonalStory,
        PastTraumaResolution,
        FutureVision,
        EthicalCommitment,
        RelationshipDialogue,
        CivicResponsibility,
        NobleTrajectory
    }

    enum CaseStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        VisionAsserted
    }

    struct Rule {
        uint256 id;
        VisionRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct Narrative {
        uint256 id;
        address author;
        NarrativeType narrativeType;
        string details;
        CaseStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => Narrative) public narratives;
    mapping(address => bool) public councilMember;

    event RuleDeclared(uint256 indexed id, VisionRule ruleType);
    event RuleLocked(uint256 indexed id);
    event NarrativeFiled(uint256 indexed id, NarrativeType narrativeType);
    event CaseStatusChanged(uint256 indexed id, CaseStatus status);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        charterCount = 0;
        narrativeCount = 0;
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
        _declare(VisionRule.NarrativeIsConstitutional, "Narrative is constitutional; denial prohibited.");
        _declare(VisionRule.EthicalResponsibilityAnchored, "Ethical responsibility anchored; abdication prohibited.");
        _declare(VisionRule.ChaosProhibited, "Chaos prohibited; vision required.");
        _declare(VisionRule.PawnhoodBlocked, "Pawnhood blocked; autonomy required.");
        _declare(VisionRule.OpportunityInResponsibility, "Opportunity lurks where responsibility is abdicated.");
        _declare(VisionRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
        _declare(VisionRule.TransparencyInVisionSystems, "Vision systems must be transparent.");
    }

    function _declare(VisionRule ruleType, string memory description) internal {
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

    function fileNarrative(
        NarrativeType narrativeType,
        string calldata details
    ) external {
        narrativeCount++;
        narratives[narrativeCount] = Narrative(
            narrativeCount,
            msg.sender,
            narrativeType,
            details,
            CaseStatus.Filed,
            0,
            block.timestamp
        );

        emit NarrativeFiled(narrativeCount, narrativeType);
    }

    function beginReview(uint256 narrativeId) external onlyCouncil {
        Narrative storage n = narratives[narrativeId];
        require(n.status == CaseStatus.Filed, "Not filed");
        n.status = CaseStatus.UnderReview;
        emit CaseStatusChanged(narrativeId, CaseStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 narrativeId) external onlyCouncil {
        Narrative storage n = narratives[narrativeId];
        require(n.status == CaseStatus.UnderReview, "Not under review");
        n.status = CaseStatus.MultiCouncilReview;
        emit CaseStatusChanged(narrativeId, CaseStatus.MultiCouncilReview);
    }

    function assertVision(uint256 narrativeId) external onlyCouncil {
        Narrative storage n = narratives[narrativeId];
        require(n.status == CaseStatus.MultiCouncilReview, "Not in council stage");

        n.approvals++;

        if (n.approvals * 2 > councilCount && councilCount > 0) {
            n.status = CaseStatus.VisionAsserted;
            emit CaseStatusChanged(narrativeId, CaseStatus.VisionAsserted);
        }
    }

    function rejectNarrative(uint256 narrativeId) external onlyCouncil {
        Narrative storage n = narratives[narrativeId];
        require(
            n.status == CaseStatus.Filed ||
            n.status == CaseStatus.UnderReview ||
            n.status == CaseStatus.MultiCouncilReview,
            "Invalid status"
        );
        n.status = CaseStatus.Rejected;
        emit CaseStatusChanged(narrativeId, CaseStatus.Rejected);
    }
}
