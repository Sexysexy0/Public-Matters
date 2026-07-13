// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Innovation Supreme Court
/// @notice Provides judicial oversight, binding rulings, and constitutional enforcement for innovation governance.
/// @dev Integrates InnovationConstitution, GlobalInnovationTreaty, BrandTrustCovenant, and CrisisLeadershipFramework.

contract InnovationSupremeCourt {
    address public guardian;
    uint256 public rulingCount;
    uint256 public appealCount;
    uint256 public justiceCount;

    enum RoleType {
        Justice,
        Council,
        Innovator,
        Founder,
        PublicServant,
        TreatyMember,
        Oversight
    }

    enum CaseType {
        ConstitutionalViolation,
        TreatyViolation,
        BrandTrustViolation,
        CrisisMismanagement,
        TransparencyFailure,
        MeritSuppression,
        RiskMisclassification,
        WeaponizedGovernance,
        FearBasedGovernance
    }

    enum CaseStatus {
        Filed,
        UnderReview,
        HearingScheduled,
        MultiJusticeReview,
        Rejected,
        FinalRulingIssued
    }

    struct Ruling {
        uint256 id;
        CaseType caseType;
        string decision;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct Appeal {
        uint256 id;
        address appellant;
        address respondent;
        CaseType caseType;
        string details;
        CaseStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Ruling) public rulings;
    mapping(uint256 => Appeal) public appeals;
    mapping(address => RoleType) public roles;
    mapping(address => bool) public justices;

    event RulingDeclared(uint256 indexed id, CaseType caseType);
    event RulingLocked(uint256 indexed id);
    event AppealFiled(uint256 indexed id, CaseType caseType);
    event CaseStatusChanged(uint256 indexed id, CaseStatus status);
    event JusticeAdded(address indexed member);
    event JusticeRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        rulingCount = 0;
        appealCount = 0;
        justiceCount = 0;
    }

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Guardian only");
        _;
    }

    modifier onlyJustice() {
        require(justices[msg.sender], "Justice only");
        _;
    }

    function assignRole(address account, RoleType role) external onlyGuardian {
        roles[account] = role;
    }

    function addJustice(address member) external onlyGuardian {
        require(!justices[member], "Already justice");
        justices[member] = true;
        justiceCount++;
        emit JusticeAdded(member);
    }

    function removeJustice(address member) external onlyGuardian {
        require(justices[member], "Not justice");
        justices[member] = false;
        justiceCount--;
        emit JusticeRemoved(member);
    }

    function fileAppeal(
        address respondent,
        CaseType caseType,
        string calldata details
    ) external {
        appealCount++;
        appeals[appealCount] = Appeal(
            appealCount,
            msg.sender,
            respondent,
            caseType,
            details,
            CaseStatus.Filed,
            0,
            block.timestamp
        );

        emit AppealFiled(appealCount, caseType);
    }

    function beginReview(uint256 appealId) external onlyJustice {
        Appeal storage a = appeals[appealId];
        require(a.status == CaseStatus.Filed, "Not filed");
        a.status = CaseStatus.UnderReview;
        emit CaseStatusChanged(appealId, CaseStatus.UnderReview);
    }

    function scheduleHearing(uint256 appealId) external onlyJustice {
        Appeal storage a = appeals[appealId];
        require(a.status == CaseStatus.UnderReview, "Not under review");
        a.status = CaseStatus.HearingScheduled;
        emit CaseStatusChanged(appealId, CaseStatus.HearingScheduled);
    }

    function escalateToMultiJustice(uint256 appealId) external onlyJustice {
        Appeal storage a = appeals[appealId];
        require(a.status == CaseStatus.HearingScheduled, "Not scheduled");
        a.status = CaseStatus.MultiJusticeReview;
        emit CaseStatusChanged(appealId, CaseStatus.MultiJusticeReview);
    }

    function issueFinalRuling(uint256 appealId, string calldata decision) external onlyJustice {
        Appeal storage a = appeals[appealId];
        require(a.status == CaseStatus.MultiJusticeReview, "Not in review stage");

        rulingCount++;
        rulings[rulingCount] = Ruling(
            rulingCount,
            a.caseType,
            decision,
            true,
            block.timestamp
        );

        a.status = CaseStatus.FinalRulingIssued;
        emit CaseStatusChanged(appealId, CaseStatus.FinalRulingIssued);
        emit RulingDeclared(rulingCount, a.caseType);
    }

    function rejectAppeal(uint256 appealId) external onlyJustice {
        Appeal storage a = appeals[appealId];
        require(
            a.status == CaseStatus.Filed ||
            a.status == CaseStatus.UnderReview ||
            a.status == CaseStatus.HearingScheduled ||
            a.status == CaseStatus.MultiJusticeReview,
            "Invalid status"
        );
        a.status = CaseStatus.Rejected;
        emit CaseStatusChanged(appealId, CaseStatus.Rejected);
    }
}
