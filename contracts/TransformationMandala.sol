// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Transformation Mandala
/// @notice Encodes safeguard for systemic transformation through defender + individual synergy.
/// @dev Complements DefenderSynergyOracle, EnergyMatchMandala, and IdentityRebuildMandala.

contract TransformationMandala {
    address public guardian;
    uint256 public mandalaCount;
    uint256 public councilCount;

    enum TransformationRule {
        TransformationIsConstitutional,
        SynergyMandated,
        StagnationSuppressed,
        TransparencyInTransformationSystems,
        PublicBenefitPriority
    }

    enum TransformationStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        TransformationConfirmed
    }

    struct Rule {
        uint256 id;
        TransformationRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct TransformationCase {
        uint256 id;
        address proposer;
        string grounds;
        TransformationStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => TransformationCase) public transformationCases;
    mapping(address => bool) public councilMember;

    event RuleDeclared(uint256 indexed id, TransformationRule ruleType);
    event RuleLocked(uint256 indexed id);
    event TransformationFiled(uint256 indexed id);
    event TransformationStatusChanged(uint256 indexed id, TransformationStatus status);
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
        _declare(TransformationRule.TransformationIsConstitutional, "Transformation is constitutional; denial prohibited.");
        _declare(TransformationRule.SynergyMandated, "Synergy mandated; defender + individual must co-create.");
        _declare(TransformationRule.StagnationSuppressed, "Stagnation suppressed; fairness required.");
        _declare(TransformationRule.TransparencyInTransformationSystems, "Transformation systems must be transparent.");
        _declare(TransformationRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
    }

    function _declare(TransformationRule ruleType, string memory description) internal {
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

    function fileTransformationCase(string calldata grounds) external {
        mandalaCount++;
        transformationCases[mandalaCount] = TransformationCase(
            mandalaCount,
            msg.sender,
            grounds,
            TransformationStatus.Filed,
            0,
            block.timestamp
        );

        emit TransformationFiled(mandalaCount);
    }

    function beginReview(uint256 transformationId) external onlyCouncil {
        TransformationCase storage t = transformationCases[transformationId];
        require(t.status == TransformationStatus.Filed, "Not filed");
        t.status = TransformationStatus.UnderReview;
        emit TransformationStatusChanged(transformationId, TransformationStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 transformationId) external onlyCouncil {
        TransformationCase storage t = transformationCases[transformationId];
        require(t.status == TransformationStatus.UnderReview, "Not under review");
        t.status = TransformationStatus.MultiCouncilReview;
        emit TransformationStatusChanged(transformationId, TransformationStatus.MultiCouncilReview);
    }

    function confirmTransformation(uint256 transformationId) external onlyCouncil {
        TransformationCase storage t = transformationCases[transformationId];
        require(t.status == TransformationStatus.MultiCouncilReview, "Not in council stage");

        t.approvals++;

        if (t.approvals * 2 > councilCount && councilCount > 0) {
            t.status = TransformationStatus.TransformationConfirmed;
            emit TransformationStatusChanged(transformationId, TransformationStatus.TransformationConfirmed);
        }
    }

    function rejectTransformation(uint256 transformationId) external onlyCouncil {
        TransformationCase storage t = transformationCases[transformationId];
        require(
            t.status == TransformationStatus.Filed ||
            t.status == TransformationStatus.UnderReview ||
            t.status == TransformationStatus.MultiCouncilReview,
            "Invalid status"
        );
        t.status = TransformationStatus.Rejected;
        emit TransformationStatusChanged(transformationId, TransformationStatus.Rejected);
    }
}
