// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Decision Format Framework
/// @notice Encodes decision format safeguard.
/// @dev Complements FreeSpeechMandala, CaseLawCodification, and PanelistQuality.

contract DecisionFormatFramework {
    address public guardian;
    uint256 public formatCount;
    uint256 public councilCount;

    enum FormatRule {
        ReadabilityIsConstitutional,
        UniformTemplateRequired,
        MachineSearchabilityEncouraged,
        TransparencyInDecisionSystems,
        PublicBenefitPriority
    }

    enum FormatStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        FormatConfirmed
    }

    struct Rule {
        uint256 id;
        FormatRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct FormatProposal {
        uint256 id;
        address proposer;
        string templateReference;
        string grounds;
        FormatStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => FormatProposal) public proposals;
    mapping(address => bool) public councilMember;

    event RuleDeclared(uint256 indexed id, FormatRule ruleType);
    event RuleLocked(uint256 indexed id);
    event ProposalFiled(uint256 indexed id, string templateReference);
    event FormatStatusChanged(uint256 indexed id, FormatStatus status);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        formatCount = 0;
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
        _declare(FormatRule.ReadabilityIsConstitutional, "Readability is constitutional; denial prohibited.");
        _declare(FormatRule.UniformTemplateRequired, "Uniform template required; inconsistency prohibited.");
        _declare(FormatRule.MachineSearchabilityEncouraged, "Machine searchability encouraged; burdens minimized.");
        _declare(FormatRule.TransparencyInDecisionSystems, "Decision systems must be transparent.");
        _declare(FormatRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
    }

    function _declare(FormatRule ruleType, string memory description) internal {
        formatCount++;
        rules[formatCount] = Rule(
            formatCount,
            ruleType,
            description,
            false,
            block.timestamp
        );
        emit RuleDeclared(formatCount, ruleType);
    }

    function lockRule(uint256 id) external onlyGuardian {
        Rule storage r = rules[id];
        require(!r.immutableEntry, "Already immutable");
        r.immutableEntry = true;
        emit RuleLocked(id);
    }

    function fileProposal(
        string calldata templateReference,
        string calldata grounds
    ) external {
        formatCount++;
        proposals[formatCount] = FormatProposal(
            formatCount,
            msg.sender,
            templateReference,
            grounds,
            FormatStatus.Filed,
            0,
            block.timestamp
        );

        emit ProposalFiled(formatCount, templateReference);
    }

    function beginReview(uint256 proposalId) external onlyCouncil {
        FormatProposal storage p = proposals[proposalId];
        require(p.status == FormatStatus.Filed, "Not filed");
        p.status = FormatStatus.UnderReview;
        emit FormatStatusChanged(proposalId, FormatStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 proposalId) external onlyCouncil {
        FormatProposal storage p = proposals[proposalId];
        require(p.status == FormatStatus.UnderReview, "Not under review");
        p.status = FormatStatus.MultiCouncilReview;
        emit FormatStatusChanged(proposalId, FormatStatus.MultiCouncilReview);
    }

    function confirmFormat(uint256 proposalId) external onlyCouncil {
        FormatProposal storage p = proposals[proposalId];
        require(p.status == FormatStatus.MultiCouncilReview, "Not in council stage");

        p.approvals++;

        if (p.approvals * 2 > councilCount && councilCount > 0) {
            p.status = FormatStatus.FormatConfirmed;
            emit FormatStatusChanged(proposalId, FormatStatus.FormatConfirmed);
        }
    }

    function rejectFormat(uint256 proposalId) external onlyCouncil {
        FormatProposal storage p = proposals[proposalId];
        require(
            p.status == FormatStatus.Filed ||
            p.status == FormatStatus.UnderReview ||
            p.status == FormatStatus.MultiCouncilReview,
            "Invalid status"
        );
        p.status = FormatStatus.Rejected;
        emit FormatStatusChanged(proposalId, FormatStatus.Rejected);
    }
}
