// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Anomaly Recognition Oracle
/// @notice Encodes safeguard for recognizing kindred spirits/anomalies in restrictive systems.
/// @dev Complements ShadowGuardianMandala, InnovationFreedomCharter, and PublicBenefitOracle.

contract AnomalyRecognitionOracle {
    address public guardian;
    uint256 public oracleCount;
    uint256 public councilCount;

    enum AnomalyRule {
        AnomalyRecognitionIsConstitutional,
        ValueMandated,
        SuppressionOfNeglect,
        TransparencyInRecognitionSystems,
        PublicBenefitPriority
    }

    enum AnomalyStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        AnomalyConfirmed
    }

    struct Rule {
        uint256 id;
        AnomalyRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct AnomalyCase {
        uint256 id;
        address proposer;
        string grounds;
        AnomalyStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => AnomalyCase) public anomalyCases;
    mapping(address => bool) public councilMember;

    event RuleDeclared(uint256 indexed id, AnomalyRule ruleType);
    event RuleLocked(uint256 indexed id);
    event AnomalyFiled(uint256 indexed id);
    event AnomalyStatusChanged(uint256 indexed id, AnomalyStatus status);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        oracleCount = 0;
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
        _declare(AnomalyRule.AnomalyRecognitionIsConstitutional, "Anomaly recognition is constitutional; denial prohibited.");
        _declare(AnomalyRule.ValueMandated, "Value mandated; neglect blocked.");
        _declare(AnomalyRule.SuppressionOfNeglect, "Neglect suppressed; fairness required.");
        _declare(AnomalyRule.TransparencyInRecognitionSystems, "Recognition systems must be transparent.");
        _declare(AnomalyRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
    }

    function _declare(AnomalyRule ruleType, string memory description) internal {
        oracleCount++;
        rules[oracleCount] = Rule(
            oracleCount,
            ruleType,
            description,
            false,
            block.timestamp
        );
        emit RuleDeclared(oracleCount, ruleType);
    }

    function lockRule(uint256 id) external onlyGuardian {
        Rule storage r = rules[id];
        require(!r.immutableEntry, "Already immutable");
        r.immutableEntry = true;
        emit RuleLocked(id);
    }

    function fileAnomalyCase(string calldata grounds) external {
        oracleCount++;
        anomalyCases[oracleCount] = AnomalyCase(
            oracleCount,
            msg.sender,
            grounds,
            AnomalyStatus.Filed,
            0,
            block.timestamp
        );

        emit AnomalyFiled(oracleCount);
    }

    function beginReview(uint256 anomalyId) external onlyCouncil {
        AnomalyCase storage a = anomalyCases[anomalyId];
        require(a.status == AnomalyStatus.Filed, "Not filed");
        a.status = AnomalyStatus.UnderReview;
        emit AnomalyStatusChanged(anomalyId, AnomalyStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 anomalyId) external onlyCouncil {
        AnomalyCase storage a = anomalyCases[anomalyId];
        require(a.status == AnomalyStatus.UnderReview, "Not under review");
        a.status = AnomalyStatus.MultiCouncilReview;
        emit AnomalyStatusChanged(anomalyId, AnomalyStatus.MultiCouncilReview);
    }

    function confirmAnomaly(uint256 anomalyId) external onlyCouncil {
        AnomalyCase storage a = anomalyCases[anomalyId];
        require(a.status == AnomalyStatus.MultiCouncilReview, "Not in council stage");

        a.approvals++;

        if (a.approvals * 2 > councilCount && councilCount > 0) {
            a.status = AnomalyStatus.AnomalyConfirmed;
            emit AnomalyStatusChanged(anomalyId, AnomalyStatus.AnomalyConfirmed);
        }
    }

    function rejectAnomaly(uint256 anomalyId) external onlyCouncil {
        AnomalyCase storage a = anomalyCases[anomalyId];
        require(
            a.status == AnomalyStatus.Filed ||
            a.status == AnomalyStatus.UnderReview ||
            a.status == AnomalyStatus.MultiCouncilReview,
            "Invalid status"
        );
        a.status = AnomalyStatus.Rejected;
        emit AnomalyStatusChanged(anomalyId, AnomalyStatus.Rejected);
    }
}
