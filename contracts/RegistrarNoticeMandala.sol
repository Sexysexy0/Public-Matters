// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Registrar Notice Mandala
/// @notice Encodes registrar notice safeguard.
/// @dev Complements RegistrarComplianceFramework, DecisionFormatFramework, and ComplaintWithdrawalTreaty.

contract RegistrarNoticeMandala {
    address public guardian;
    uint256 public noticeCount;
    uint256 public councilCount;

    enum NoticeRule {
        NoticeIsConstitutional,
        PromptNotificationRequired,
        LackOfNoticeSuppressed,
        TransparencyInNoticeSystems,
        PublicBenefitPriority
    }

    enum NoticeStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        NoticeConfirmed
    }

    struct Rule {
        uint256 id;
        NoticeRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct Notice {
        uint256 id;
        address proposer;
        string registrarReference;
        string grounds;
        NoticeStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => Notice) public notices;
    mapping(address => bool) public councilMember;

    event RuleDeclared(uint256 indexed id, NoticeRule ruleType);
    event RuleLocked(uint256 indexed id);
    event NoticeFiled(uint256 indexed id, string registrarReference);
    event NoticeStatusChanged(uint256 indexed id, NoticeStatus status);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        noticeCount = 0;
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
        _declare(NoticeRule.NoticeIsConstitutional, "Notice is constitutional; denial prohibited.");
        _declare(NoticeRule.PromptNotificationRequired, "Prompt notification required; delay prohibited.");
        _declare(NoticeRule.LackOfNoticeSuppressed, "Lack of notice suppressed; fairness required.");
        _declare(NoticeRule.TransparencyInNoticeSystems, "Notice systems must be transparent.");
        _declare(NoticeRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
    }

    function _declare(NoticeRule ruleType, string memory description) internal {
        noticeCount++;
        rules[noticeCount] = Rule(
            noticeCount,
            ruleType,
            description,
            false,
            block.timestamp
        );
        emit RuleDeclared(noticeCount, ruleType);
    }

    function lockRule(uint256 id) external onlyGuardian {
        Rule storage r = rules[id];
        require(!r.immutableEntry, "Already immutable");
        r.immutableEntry = true;
        emit RuleLocked(id);
    }

    function fileNotice(
        string calldata registrarReference,
        string calldata grounds
    ) external {
        noticeCount++;
        notices[noticeCount] = Notice(
            noticeCount,
            msg.sender,
            registrarReference,
            grounds,
            NoticeStatus.Filed,
            0,
            block.timestamp
        );

        emit NoticeFiled(noticeCount, registrarReference);
    }

    function beginReview(uint256 noticeId) external onlyCouncil {
        Notice storage n = notices[noticeId];
        require(n.status == NoticeStatus.Filed, "Not filed");
        n.status = NoticeStatus.UnderReview;
        emit NoticeStatusChanged(noticeId, NoticeStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 noticeId) external onlyCouncil {
        Notice storage n = notices[noticeId];
        require(n.status == NoticeStatus.UnderReview, "Not under review");
        n.status = NoticeStatus.MultiCouncilReview;
        emit NoticeStatusChanged(noticeId, NoticeStatus.MultiCouncilReview);
    }

    function confirmNotice(uint256 noticeId) external onlyCouncil {
        Notice storage n = notices[noticeId];
        require(n.status == NoticeStatus.MultiCouncilReview, "Not in council stage");

        n.approvals++;

        if (n.approvals * 2 > councilCount && councilCount > 0) {
            n.status = NoticeStatus.NoticeConfirmed;
            emit NoticeStatusChanged(noticeId, NoticeStatus.NoticeConfirmed);
        }
    }

    function rejectNotice(uint256 noticeId) external onlyCouncil {
        Notice storage n = notices[noticeId];
        require(
            n.status == NoticeStatus.Filed ||
            n.status == NoticeStatus.UnderReview ||
            n.status == NoticeStatus.MultiCouncilReview,
            "Invalid status"
        );
        n.status = NoticeStatus.Rejected;
        emit NoticeStatusChanged(noticeId, NoticeStatus.Rejected);
    }
}
