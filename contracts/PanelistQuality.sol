// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Panelist Quality Framework
/// @notice Encodes panelist accreditation and quality safeguard.
/// @dev Complements CaseLawCodification, ExpeditedProcedureFramework, and AppealsMandala.

contract PanelistQuality {
    address public guardian;
    uint256 public qualityCount;
    uint256 public councilCount;

    enum QualityRule {
        AccreditationIsConstitutional,
        TrainingMandated,
        BiasSuppressed,
        TransparencyInPanelistSystems,
        PublicBenefitPriority
    }

    enum QualityStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        QualityConfirmed
    }

    struct Rule {
        uint256 id;
        QualityRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct QualityCase {
        uint256 id;
        address proposer;
        string grounds;
        QualityStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => QualityCase) public qualityCases;
    mapping(address => bool) public councilMember;

    event RuleDeclared(uint256 indexed id, QualityRule ruleType);
    event RuleLocked(uint256 indexed id);
    event QualityFiled(uint256 indexed id);
    event QualityStatusChanged(uint256 indexed id, QualityStatus status);
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
        _declare(QualityRule.TrainingMandated, "Training mandated; bias blocked.");
        _declare(QualityRule.BiasSuppressed, "Bias suppressed; fairness required.");
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

    function fileQualityCase(string calldata grounds) external {
        qualityCount++;
        qualityCases[qualityCount] = QualityCase(
            qualityCount,
            msg.sender,
            grounds,
            QualityStatus.Filed,
            0,
            block.timestamp
        );

        emit QualityFiled(qualityCount);
    }

    function beginReview(uint256 qualityId) external onlyCouncil {
        QualityCase storage q = qualityCases[qualityId];
        require(q.status == QualityStatus.Filed, "Not filed");
        q.status = QualityStatus.UnderReview;
        emit QualityStatusChanged(qualityId, QualityStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 qualityId) external onlyCouncil {
        QualityCase storage q = qualityCases[qualityId];
        require(q.status == QualityStatus.UnderReview, "Not under review");
        q.status = QualityStatus.MultiCouncilReview;
        emit QualityStatusChanged(qualityId, QualityStatus.MultiCouncilReview);
    }

    function confirmQuality(uint256 qualityId) external onlyCouncil {
        QualityCase storage q = qualityCases[qualityId];
        require(q.status == QualityStatus.MultiCouncilReview, "Not in council stage");

        q.approvals++;

        if (q.approvals * 2 > councilCount && councilCount > 0) {
            q.status = QualityStatus.QualityConfirmed;
            emit QualityStatusChanged(qualityId, QualityStatus.QualityConfirmed);
        }
    }

    function rejectQuality(uint256 qualityId) external onlyCouncil {
        QualityCase storage q = qualityCases[qualityId];
        require(
            q.status == QualityStatus.Filed ||
            q.status == QualityStatus.UnderReview ||
            q.status == QualityStatus.MultiCouncilReview,
            "Invalid status"
        );
        q.status = QualityStatus.Rejected;
        emit QualityStatusChanged(qualityId, QualityStatus.Rejected);
    }
}
