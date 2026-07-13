// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Appeals Mandala
/// @notice Encodes appeals safeguard layer.
/// @dev Complements JusticeMandala, VisionCharter, and GoodwillTreaty.

contract AppealsMandala {
    address public guardian;
    uint256 public appealCount;
    uint256 public councilCount;

    enum AppealRule {
        AppealsIsConstitutional,
        StabilityAnchored,
        FairnessRequired,
        DueProcessProtected,
        PanelReviewEnabled,
        PublicBenefitPriority,
        TransparencyInAppealsSystems
    }

    enum AppealStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        AppealGranted,
        AppealDenied
    }

    struct Rule {
        uint256 id;
        AppealRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct Appeal {
        uint256 id;
        address appellant;
        address respondent;
        string caseReference;
        string grounds;
        AppealStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => Appeal) public appeals;
    mapping(address => bool) public councilMember;

    event RuleDeclared(uint256 indexed id, AppealRule ruleType);
    event RuleLocked(uint256 indexed id);
    event AppealFiled(uint256 indexed id, string caseReference);
    event AppealStatusChanged(uint256 indexed id, AppealStatus status);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        appealCount = 0;
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
        _declare(AppealRule.AppealsIsConstitutional, "Appeals are constitutional; denial prohibited.");
        _declare(AppealRule.StabilityAnchored, "Stability anchored; fairness required.");
        _declare(AppealRule.FairnessRequired, "Fairness required; imbalance prohibited.");
        _declare(AppealRule.DueProcessProtected, "Due process protected; violation blocked.");
        _declare(AppealRule.PanelReviewEnabled, "Panel review enabled; oversight required.");
        _declare(AppealRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
        _declare(AppealRule.TransparencyInAppealsSystems, "Appeals systems must be transparent.");
    }

    function _declare(AppealRule ruleType, string memory description) internal {
        uint256 id = appealCount + 1;
        rules[id] = Rule(id, ruleType, description, false, block.timestamp);
        emit RuleDeclared(id, ruleType);
    }

    function lockRule(uint256 id) external onlyGuardian {
        Rule storage r = rules[id];
        require(!r.immutableEntry, "Already immutable");
        r.immutableEntry = true;
        emit RuleLocked(id);
    }

    function fileAppeal(
        address respondent,
        string calldata caseReference,
        string calldata grounds
    ) external {
        appealCount++;
        appeals[appealCount] = Appeal(
            appealCount,
            msg.sender,
            respondent,
            caseReference,
            grounds,
            AppealStatus.Filed,
            0,
            block.timestamp
        );

        emit AppealFiled(appealCount, caseReference);
    }

    function beginReview(uint256 appealId) external onlyCouncil {
        Appeal storage a = appeals[appealId];
        require(a.status == AppealStatus.Filed, "Not filed");
        a.status = AppealStatus.UnderReview;
        emit AppealStatusChanged(appealId, AppealStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 appealId) external onlyCouncil {
        Appeal storage a = appeals[appealId];
        require(a.status == AppealStatus.UnderReview, "Not under review");
        a.status = AppealStatus.MultiCouncilReview;
        emit AppealStatusChanged(appealId, AppealStatus.MultiCouncilReview);
    }

    function grantAppeal(uint256 appealId) external onlyCouncil {
        Appeal storage a = appeals[appealId];
        require(a.status == AppealStatus.MultiCouncilReview, "Not in council stage");

        a.approvals++;

        if (a.approvals * 2 > councilCount && councilCount > 0) {
            a.status = AppealStatus.AppealGranted;
            emit AppealStatusChanged(appealId, AppealStatus.AppealGranted);
        }
    }

    function denyAppeal(uint256 appealId) external onlyCouncil {
        Appeal storage a = appeals[appealId];
        require(
            a.status == AppealStatus.Filed ||
            a.status == AppealStatus.UnderReview ||
            a.status == AppealStatus.MultiCouncilReview,
            "Invalid status"
        );
        a.status = AppealStatus.AppealDenied;
        emit AppealStatusChanged(appealId, AppealStatus.AppealDenied);
    }
}
