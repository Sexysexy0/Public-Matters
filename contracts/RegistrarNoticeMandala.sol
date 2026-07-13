// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Registrar Notice Mandala
/// @notice Encodes registrar duties and notice safeguards.
/// @dev Complements PublicBenefitOracle, BureaucraticAccountability, and InnovationSafetyCovenant.

contract RegistrarNoticeMandala {
    address public guardian;
    uint256 public noticeCount;
    uint256 public councilCount;

    enum RegistrarRule {
        ContactDetailsMandatory,
        SanctionOnFalseData,
        TransparencyMandated,
        PaymentBeforeActivation,
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
        RegistrarRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct NoticeCase {
        uint256 id;
        address proposer;
        string grounds;
        NoticeStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => NoticeCase) public noticeCases;
    mapping(address => bool) public councilMember;

    event RuleDeclared(uint256 indexed id, RegistrarRule ruleType);
    event RuleLocked(uint256 indexed id);
    event NoticeFiled(uint256 indexed id);
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
        _declare(RegistrarRule.ContactDetailsMandatory, "Contact details mandatory; denial prohibited.");
        _declare(RegistrarRule.SanctionOnFalseData, "Sanction on false data; accountability required.");
        _declare(RegistrarRule.TransparencyMandated, "Transparency mandated; opacity blocked.");
        _declare(RegistrarRule.PaymentBeforeActivation, "Payment required before activation; hoarding blocked.");
        _declare(RegistrarRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
    }

    function _declare(RegistrarRule ruleType, string memory description) internal {
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

    function fileNoticeCase(string calldata grounds) external {
        noticeCount++;
        noticeCases[noticeCount] = NoticeCase(
            noticeCount,
            msg.sender,
            grounds,
            NoticeStatus.Filed,
            0,
            block.timestamp
        );

        emit NoticeFiled(noticeCount);
    }

    function beginReview(uint256 noticeId) external onlyCouncil {
        NoticeCase storage n = noticeCases[noticeId];
        require(n.status == NoticeStatus.Filed, "Not filed");
        n.status = NoticeStatus.UnderReview;
        emit NoticeStatusChanged(noticeId, NoticeStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 noticeId) external onlyCouncil {
        NoticeCase storage n = noticeCases[noticeId];
        require(n.status == NoticeStatus.UnderReview, "Not under review");
        n.status = NoticeStatus.MultiCouncilReview;
        emit NoticeStatusChanged(noticeId, NoticeStatus.MultiCouncilReview);
    }

    function confirmNotice(uint256 noticeId) external onlyCouncil {
        NoticeCase storage n = noticeCases[noticeId];
        require(n.status == NoticeStatus.MultiCouncilReview, "Not in council stage");

        n.approvals++;

        if (n.approvals * 2 > councilCount && councilCount > 0) {
            n.status = NoticeStatus.NoticeConfirmed;
            emit NoticeStatusChanged(noticeId, NoticeStatus.NoticeConfirmed);
        }
    }

    function rejectNotice(uint256 noticeId) external onlyCouncil {
        NoticeCase storage n = noticeCases[noticeId];
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
