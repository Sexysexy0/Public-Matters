// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Panelist Quality
/// @notice Encodes panelist accreditation and quality safeguards.
/// @dev Complements AppealsMandala, RemedyCancellation, and JusticeMandala.

contract PanelistQuality {
    address public guardian;
    uint256 public qualityCount;
    uint256 public councilCount;

    enum QualityRule {
        AccreditationIsConstitutional,
        PerformanceReviewEnabled,
        ContinuingEducationRequired,
        BiasSuppressed,
        TransparencyInPanelistSystems,
        PublicBenefitPriority
    }

    enum ReviewStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        ReviewConfirmed
    }

    struct Rule {
        uint256 id;
        QualityRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct Review {
        uint256 id;
        address complainant;
        address panelist;
        string grounds;
        ReviewStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => Review) public reviews;
    mapping(address => bool) public councilMember;

    event RuleDeclared(uint256 indexed id, QualityRule ruleType);
    event RuleLocked(uint256 indexed id);
    event ReviewFiled(uint256 indexed id, address panelist);
    event ReviewStatusChanged(uint256 indexed id, ReviewStatus status);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        qualityCount = 0;
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
        _declare(QualityRule.AccreditationIsConstitutional, "Accreditation is constitutional; denial prohibited.");
        _declare(QualityRule.PerformanceReviewEnabled, "Performance review enabled; oversight required.");
        _declare(QualityRule.ContinuingEducationRequired, "Continuing education required; stagnation prohibited.");
        _declare(QualityRule.BiasSuppressed, "Bias suppressed; impartiality required.");
        _declare(QualityRule.TransparencyInPanelistSystems, "Panelist systems must be transparent.");
        _declare(QualityRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
    }

    function _declare(QualityRule ruleType, string memory description) internal {
        qualityCount++;
        rules[qualityCount] = Rule(
            qualityCount,
            ruleType,
            description,
            false,
            block.timestamp
        );
        emit RuleDeclared(qualityCount, ruleType);
    }

    function lockRule(uint256 id) external onlyGuardian {
        Rule storage r = rules[id];
        require(!r.immutableEntry, "Already immutable");
        r.immutableEntry = true;
        emit RuleLocked(id);
    }

    function fileReview(
        address panelist,
        string calldata grounds
    ) external {
        qualityCount++;
        reviews[qualityCount] = Review(
            qualityCount,
            msg.sender,
            panelist,
            grounds,
            ReviewStatus.Filed,
            0,
            block.timestamp
        );

        emit ReviewFiled(qualityCount, panelist);
    }

    function beginReview(uint256 reviewId) external onlyCouncil {
        Review storage r = reviews[reviewId];
        require(r.status == ReviewStatus.Filed, "Not filed");
        r.status = ReviewStatus.UnderReview;
        emit ReviewStatusChanged(reviewId, ReviewStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 reviewId) external onlyCouncil {
        Review storage r = reviews[reviewId];
        require(r.status == ReviewStatus.UnderReview, "Not under review");
        r.status = ReviewStatus.MultiCouncilReview;
        emit ReviewStatusChanged(reviewId, ReviewStatus.MultiCouncilReview);
    }

    function confirmReview(uint256 reviewId) external onlyCouncil {
        Review storage r = reviews[reviewId];
        require(r.status == ReviewStatus.MultiCouncilReview, "Not in council stage");

        r.approvals++;

        if (r.approvals * 2 > councilCount && councilCount > 0) {
            r.status = ReviewStatus.ReviewConfirmed;
            emit ReviewStatusChanged(reviewId, ReviewStatus.ReviewConfirmed);
        }
    }

    function rejectReview(uint256 reviewId) external onlyCouncil {
        Review storage r = reviews[reviewId];
        require(
            r.status == ReviewStatus.Filed ||
            r.status == ReviewStatus.UnderReview ||
            r.status == ReviewStatus.MultiCouncilReview,
            "Invalid status"
        );
        r.status = ReviewStatus.Rejected;
        emit ReviewStatusChanged(reviewId, ReviewStatus.Rejected);
    }
}
