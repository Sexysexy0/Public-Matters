// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Transparency Mandala
/// @notice Encodes safeguard for systemic transparency — accountability across all contracts.
/// @dev Complements CollectivePriorityOracle, PublicBenefitMandala, DataSovereigntyOracle, and InnovationConstitution.

contract TransparencyMandala {
    address public guardian;
    uint256 public mandalaCount;
    uint256 public councilCount;

    enum TransparencyRule {
        TransparencyIsConstitutional,
        AccountabilityMandated,
        DormantSafeguardsVisible,
        PublicAuditEnabled,
        CollectivePriorityAnchored
    }

    enum TransparencyStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        TransparencyConfirmed
    }

    struct Rule {
        uint256 id;
        TransparencyRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct TransparencyCase {
        uint256 id;
        address proposer;
        string grounds;
        TransparencyStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => TransparencyCase) public transparencyCases;
    mapping(address => bool) public councilMember;

    event RuleDeclared(uint256 indexed id, TransparencyRule ruleType);
    event RuleLocked(uint256 indexed id);
    event TransparencyFiled(uint256 indexed id);
    event TransparencyStatusChanged(uint256 indexed id, TransparencyStatus status);
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
        _declare(TransparencyRule.TransparencyIsConstitutional, "Transparency is constitutional; denial prohibited.");
        _declare(TransparencyRule.AccountabilityMandated, "Accountability mandated; systemic fairness enforced.");
        _declare(TransparencyRule.DormantSafeguardsVisible, "Dormant safeguards visible; hidden clauses auditable.");
        _declare(TransparencyRule.PublicAuditEnabled, "Public audit enabled; systems open to scrutiny.");
        _declare(TransparencyRule.CollectivePriorityAnchored, "Collective priority anchored; masa protected.");
    }

    function _declare(TransparencyRule ruleType, string memory description) internal {
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

    function fileTransparencyCase(string calldata grounds) external {
        mandalaCount++;
        transparencyCases[mandalaCount] = TransparencyCase(
            mandalaCount,
            msg.sender,
            grounds,
            TransparencyStatus.Filed,
            0,
            block.timestamp
        );

        emit TransparencyFiled(mandalaCount);
    }

    function beginReview(uint256 transparencyId) external onlyCouncil {
        TransparencyCase storage t = transparencyCases[transparencyId];
        require(t.status == TransparencyStatus.Filed, "Not filed");
        t.status = TransparencyStatus.UnderReview;
        emit TransparencyStatusChanged(transparencyId, TransparencyStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 transparencyId) external onlyCouncil {
        TransparencyCase storage t = transparencyCases[transparencyId];
        require(t.status == TransparencyStatus.UnderReview, "Not under review");
        t.status = TransparencyStatus.MultiCouncilReview;
        emit TransparencyStatusChanged(transparencyId, TransparencyStatus.MultiCouncilReview);
    }

    function confirmTransparency(uint256 transparencyId) external onlyCouncil {
        TransparencyCase storage t = transparencyCases[transparencyId];
        require(t.status == TransparencyStatus.MultiCouncilReview, "Not in council stage");

        t.approvals++;

        if (t.approvals * 2 > councilCount && councilCount > 0) {
            t.status = TransparencyStatus.TransparencyConfirmed;
            emit TransparencyStatusChanged(transparencyId, TransparencyStatus.TransparencyConfirmed);
        }
    }

    function rejectTransparency(uint256 transparencyId) external onlyCouncil {
        TransparencyCase storage t = transparencyCases[transparencyId];
        require(
            t.status == TransparencyStatus.Filed ||
            t.status == TransparencyStatus.UnderReview ||
            t.status == TransparencyStatus.MultiCouncilReview,
            "Invalid status"
        );
        t.status = TransparencyStatus.Rejected;
        emit TransparencyStatusChanged(transparencyId, TransparencyStatus.Rejected);
    }
}
