// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Appeals Mandala
/// @notice Encodes appeals safeguard.
/// @dev Complements RegistrarNoticeMandala, RegistrarComplianceFramework, and ComplaintWithdrawalTreaty.

contract AppealsMandala {
    address public guardian;
    uint256 public appealsCount;
    uint256 public councilCount;

    enum AppealsRule {
        AppealsIsConstitutional,
        RightToReviewMandated,
        DenialOfAppealSuppressed,
        MultiCouncilAppealsRequired,
        TransparencyInAppealsSystems,
        PublicBenefitPriority
    }

    enum AppealsStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        AppealConfirmed
    }

    struct Rule {
        uint256 id;
        AppealsRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct Appeal {
        uint256 id;
        address appellant;
        string caseReference;
        string grounds;
        AppealsStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => Appeal) public appeals;
    mapping(address => bool) public councilMember;

    event RuleDeclared(uint256 indexed id, AppealsRule ruleType);
    event RuleLocked(uint256 indexed id);
    event AppealFiled(uint256 indexed id, string caseReference);
    event AppealStatusChanged(uint256 indexed id, AppealsStatus status);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        appealsCount = 0;
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
        _declare(AppealsRule.AppealsIsConstitutional, "Appeals are constitutional; denial prohibited.");
        _declare(AppealsRule.RightToReviewMandated, "Right to review mandated; fairness required.");
        _declare(AppealsRule.DenialOfAppealSuppressed, "Denial of appeal suppressed; dignity required.");
        _declare(AppealsRule.MultiCouncilAppealsRequired, "Multi-council appeals required; systemic clarity enforced.");
        _declare(AppealsRule.TransparencyInAppealsSystems, "Appeals systems must be transparent.");
        _declare(AppealsRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
    }

    function _declare(AppealsRule ruleType, string memory description) internal {
        appealsCount++;
        rules[appealsCount] = Rule(
            appealsCount,
            ruleType,
            description,
            false,
            block.timestamp
        );
        emit RuleDeclared(appealsCount, ruleType);
    }

    function lockRule(uint256 id) external onlyGuardian {
        Rule storage r = rules[id];
        require(!r.immutableEntry, "Already immutable");
        r.immutableEntry = true;
        emit RuleLocked(id);
    }

    function fileAppeal(
        string calldata caseReference,
        string calldata grounds
    ) external {
        appealsCount++;
        appeals[appealsCount] = Appeal(
            appealsCount,
            msg.sender,
            caseReference,
            grounds,
            AppealsStatus.Filed,
            0,
            block.timestamp
        );

        emit AppealFiled(appealsCount, caseReference);
    }

    function beginReview(uint256 appealId) external onlyCouncil {
        Appeal storage a = appeals[appealId];
        require(a.status == AppealsStatus.Filed, "Not filed");
        a.status = AppealsStatus.UnderReview;
        emit AppealStatusChanged(appealId, AppealsStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 appealId) external onlyCouncil {
        Appeal storage a = appeals[appealId];
        require(a.status == AppealsStatus.UnderReview, "Not under review");
        a.status = AppealsStatus.MultiCouncilReview;
        emit AppealStatusChanged(appealId, AppealsStatus.MultiCouncilReview);
    }

    function confirmAppeal(uint256 appealId) external onlyCouncil {
        Appeal storage a = appeals[appealId];
        require(a.status == AppealsStatus.MultiCouncilReview, "Not in council stage");

        a.approvals++;

        if (a.approvals * 2 > councilCount && councilCount > 0) {
            a.status = AppealsStatus.AppealConfirmed;
            emit AppealStatusChanged(appealId, AppealsStatus.AppealConfirmed);
        }
    }

    function rejectAppeal(uint256 appealId) external onlyCouncil {
        Appeal storage a = appeals[appealId];
        require(
            a.status == AppealsStatus.Filed ||
            a.status == AppealsStatus.UnderReview ||
            a.status == AppealsStatus.MultiCouncilReview,
            "Invalid status"
        );
        a.status = AppealsStatus.Rejected;
        emit AppealStatusChanged(appealId, AppealsStatus.Rejected);
    }
}
