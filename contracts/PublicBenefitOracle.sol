// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Public Benefit Oracle
/// @notice Evaluates whether a decision, procurement, or innovation produced public benefit.
/// @dev If public benefit is confirmed, the decision cannot be criminalized or weaponized.

contract PublicBenefitOracle {
    address public guardian;
    uint256 public metricCount;
    uint256 public evaluationCount;
    uint256 public councilCount;

    enum RoleType {
        Innovator,
        PublicServant,
        ProcurementOfficer,
        Auditor,
        Council,
        Oversight,
        FutureEntity
    }

    enum BenefitMetric {
        JobCreation,
        CostReduction,
        EfficiencyIncrease,
        EducationImprovement,
        TechnologyAdvancement,
        PublicAccessIncrease,
        ServiceQualityIncrease,
        TransparencyIncrease,
        LongTermBenefit,
        EmergencyResponseBenefit
    }

    enum EvaluationStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        ConfirmedPublicBenefit
    }

    struct Metric {
        uint256 id;
        BenefitMetric metricType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct Evaluation {
        uint256 id;
        address evaluator;
        address subject;
        BenefitMetric metricType;
        string details;
        uint256 score; // 0–100 public benefit score
        EvaluationStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Metric) public metrics;
    mapping(uint256 => Evaluation) public evaluations;
    mapping(address => RoleType) public roles;
    mapping(address => bool) public councilMember;

    event MetricDeclared(uint256 indexed id, BenefitMetric metricType);
    event MetricLocked(uint256 indexed id);
    event EvaluationFiled(uint256 indexed id, BenefitMetric metricType);
    event EvaluationStatusChanged(uint256 indexed id, EvaluationStatus status);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        metricCount = 0;
        evaluationCount = 0;
        councilCount = 0;

        _declareDefaultMetrics();
    }

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Guardian only");
        _;
    }

    modifier onlyCouncil() {
        require(councilMember[msg.sender], "Council only");
        _;
    }

    function assignRole(address account, RoleType role) external onlyGuardian {
        roles[account] = role;
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

    function _declareDefaultMetrics() internal {
        _declareMetric(BenefitMetric.JobCreation, "Decision created jobs.");
        _declareMetric(BenefitMetric.CostReduction, "Decision reduced costs.");
        _declareMetric(BenefitMetric.EfficiencyIncrease, "Decision increased efficiency.");
        _declareMetric(BenefitMetric.EducationImprovement, "Decision improved education outcomes.");
        _declareMetric(BenefitMetric.TechnologyAdvancement, "Decision advanced technology.");
        _declareMetric(BenefitMetric.PublicAccessIncrease, "Decision increased public access.");
        _declareMetric(BenefitMetric.ServiceQualityIncrease, "Decision improved service quality.");
        _declareMetric(BenefitMetric.TransparencyIncrease, "Decision increased transparency.");
        _declareMetric(BenefitMetric.LongTermBenefit, "Decision produced long-term benefit.");
        _declareMetric(BenefitMetric.EmergencyResponseBenefit, "Decision improved emergency response.");
    }

    function _declareMetric(BenefitMetric metricType, string memory description) internal {
        metricCount++;
        metrics[metricCount] = Metric(
            metricCount,
            metricType,
            description,
            false,
            block.timestamp
        );
        emit MetricDeclared(metricCount, metricType);
    }

    function lockMetric(uint256 id) external onlyGuardian {
        Metric storage m = metrics[id];
        require(!m.immutableEntry, "Already immutable");
        m.immutableEntry = true;
        emit MetricLocked(id);
    }

    function fileEvaluation(
        address subject,
        BenefitMetric metricType,
        string calldata details,
        uint256 score
    ) external {
        require(score <= 100, "Score must be 0–100");

        evaluationCount++;
        evaluations[evaluationCount] = Evaluation(
            evaluationCount,
            msg.sender,
            subject,
            metricType,
            details,
            score,
            EvaluationStatus.Filed,
            0,
            block.timestamp
        );

        emit EvaluationFiled(evaluationCount, metricType);
    }

    function beginReview(uint256 evalId) external onlyCouncil {
        Evaluation storage e = evaluations[evalId];
        require(e.status == EvaluationStatus.Filed, "Not filed");
        e.status = EvaluationStatus.UnderReview;
        emit EvaluationStatusChanged(evalId, EvaluationStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 evalId) external onlyCouncil {
        Evaluation storage e = evaluations[evalId];
        require(e.status == EvaluationStatus.UnderReview, "Not under review");
        e.status = EvaluationStatus.MultiCouncilReview;
        emit EvaluationStatusChanged(evalId, EvaluationStatus.MultiCouncilReview);
    }

    function approvePublicBenefit(uint256 evalId) external onlyCouncil {
        Evaluation storage e = evaluations[evalId];
        require(e.status == EvaluationStatus.MultiCouncilReview, "Not in council stage");

        e.approvals++;

        if (e.approvals * 2 > councilCount && councilCount > 0 && e.score >= 60) {
            e.status = EvaluationStatus.ConfirmedPublicBenefit;
            emit EvaluationStatusChanged(evalId, EvaluationStatus.ConfirmedPublicBenefit);
        }
    }

    function rejectEvaluation(uint256 evalId) external onlyCouncil {
        Evaluation storage e = evaluations[evalId];
        require(
            e.status == EvaluationStatus.Filed ||
            e.status == EvaluationStatus.UnderReview ||
            e.status == EvaluationStatus.MultiCouncilReview,
            "Invalid status"
        );
        e.status = EvaluationStatus.Rejected;
        emit EvaluationStatusChanged(evalId, EvaluationStatus.Rejected);
    }
}
