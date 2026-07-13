// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Free Speech Mandala
/// @notice Encodes free speech safeguard.
/// @dev Complements AppealsMandala, ComplaintWithdrawalTreaty, and PublicBenefitOracle.

contract FreeSpeechMandala {
    address public guardian;
    uint256 public mandalaCount;
    uint256 public councilCount;

    enum SpeechRule {
        FreeSpeechIsConstitutional,
        ExpressionMandated,
        CensorshipSuppressed,
        TransparencyInSpeechSystems,
        PublicBenefitPriority
    }

    enum SpeechStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        SpeechConfirmed
    }

    struct Rule {
        uint256 id;
        SpeechRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct SpeechCase {
        uint256 id;
        address proposer;
        string grounds;
        SpeechStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => SpeechCase) public speechCases;
    mapping(address => bool) public councilMember;

    event RuleDeclared(uint256 indexed id, SpeechRule ruleType);
    event RuleLocked(uint256 indexed id);
    event SpeechFiled(uint256 indexed id);
    event SpeechStatusChanged(uint256 indexed id, SpeechStatus status);
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
        _declare(SpeechRule.FreeSpeechIsConstitutional, "Free speech is constitutional; denial prohibited.");
        _declare(SpeechRule.ExpressionMandated, "Expression mandated; censorship blocked.");
        _declare(SpeechRule.CensorshipSuppressed, "Censorship suppressed; fairness required.");
        _declare(SpeechRule.TransparencyInSpeechSystems, "Speech systems must be transparent.");
        _declare(SpeechRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
    }

    function _declare(SpeechRule ruleType, string memory description) internal {
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

    function fileSpeechCase(string calldata grounds) external {
        mandalaCount++;
        speechCases[mandalaCount] = SpeechCase(
            mandalaCount,
            msg.sender,
            grounds,
            SpeechStatus.Filed,
            0,
            block.timestamp
        );

        emit SpeechFiled(mandalaCount);
    }

    function beginReview(uint256 speechId) external onlyCouncil {
        SpeechCase storage s = speechCases[speechId];
        require(s.status == SpeechStatus.Filed, "Not filed");
        s.status = SpeechStatus.UnderReview;
        emit SpeechStatusChanged(speechId, SpeechStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 speechId) external onlyCouncil {
        SpeechCase storage s = speechCases[speechId];
        require(s.status == SpeechStatus.UnderReview, "Not under review");
        s.status = SpeechStatus.MultiCouncilReview;
        emit SpeechStatusChanged(speechId, SpeechStatus.MultiCouncilReview);
    }

    function confirmSpeech(uint256 speechId) external onlyCouncil {
        SpeechCase storage s = speechCases[speechId];
        require(s.status == SpeechStatus.MultiCouncilReview, "Not in council stage");

        s.approvals++;

        if (s.approvals * 2 > councilCount && councilCount > 0) {
            s.status = SpeechStatus.SpeechConfirmed;
            emit SpeechStatusChanged(speechId, SpeechStatus.SpeechConfirmed);
        }
    }

    function rejectSpeech(uint256 speechId) external onlyCouncil {
        SpeechCase storage s = speechCases[speechId];
        require(
            s.status == SpeechStatus.Filed ||
            s.status == SpeechStatus.UnderReview ||
            s.status == SpeechStatus.MultiCouncilReview,
            "Invalid status"
        );
        s.status = SpeechStatus.Rejected;
        emit SpeechStatusChanged(speechId, SpeechStatus.Rejected);
    }
}
