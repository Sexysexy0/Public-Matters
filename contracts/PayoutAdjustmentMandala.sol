// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Payout Adjustment Mandala
/// @notice Encodes safeguard for balancing participation bonuses with total payout.
/// @dev Complements ParticipationBonusMandala, InnovationMeritShield, and PublicBenefitOracle.

contract PayoutAdjustmentMandala {
    address public guardian;
    uint256 public mandalaCount;
    uint256 public councilCount;

    enum AdjustmentRule {
        PayoutAdjustmentIsConstitutional,
        BalanceMandated,
        OverpaymentSuppressed,
        TransparencyInAdjustmentSystems,
        PublicBenefitPriority
    }

    enum AdjustmentStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        AdjustmentConfirmed
    }

    struct Rule {
        uint256 id;
        AdjustmentRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct AdjustmentCase {
        uint256 id;
        address proposer;
        string grounds;
        AdjustmentStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => AdjustmentCase) public adjustmentCases;
    mapping(address => bool) public councilMember;

    event RuleDeclared(uint256 indexed id, AdjustmentRule ruleType);
    event RuleLocked(uint256 indexed id);
    event AdjustmentFiled(uint256 indexed id);
    event AdjustmentStatusChanged(uint256 indexed id, AdjustmentStatus status);
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
        _declare(AdjustmentRule.PayoutAdjustmentIsConstitutional, "Payout adjustment is constitutional; denial prohibited.");
        _declare(AdjustmentRule.BalanceMandated, "Balance mandated; overpayment blocked.");
        _declare(AdjustmentRule.OverpaymentSuppressed, "Overpayment suppressed; fairness required.");
        _declare(AdjustmentRule.TransparencyInAdjustmentSystems, "Adjustment systems must be transparent.");
        _declare(AdjustmentRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
    }

    function _declare(AdjustmentRule ruleType, string memory description) internal {
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

    function fileAdjustmentCase(string calldata grounds) external {
        mandalaCount++;
        adjustmentCases[mandalaCount] = AdjustmentCase(
            mandalaCount,
            msg.sender,
            grounds,
            AdjustmentStatus.Filed,
            0,
            block.timestamp
        );

        emit AdjustmentFiled(mandalaCount);
    }

    function beginReview(uint256 adjustmentId) external onlyCouncil {
        AdjustmentCase storage a = adjustmentCases[adjustmentId];
        require(a.status == AdjustmentStatus.Filed, "Not filed");
        a.status = AdjustmentStatus.UnderReview;
        emit AdjustmentStatusChanged(adjustmentId, AdjustmentStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 adjustmentId) external onlyCouncil {
        AdjustmentCase storage a = adjustmentCases[adjustmentId];
        require(a.status == AdjustmentStatus.UnderReview, "Not under review");
        a.status = AdjustmentStatus.MultiCouncilReview;
        emit AdjustmentStatusChanged(adjustmentId, AdjustmentStatus.MultiCouncilReview);
    }

    function confirmAdjustment(uint256 adjustmentId) external onlyCouncil {
        AdjustmentCase storage a = adjustmentCases[adjustmentId];
        require(a.status == AdjustmentStatus.MultiCouncilReview, "Not in council stage");

        a.approvals++;

        if (a.approvals * 2 > councilCount && councilCount > 0) {
            a.status = AdjustmentStatus.AdjustmentConfirmed;
            emit AdjustmentStatusChanged(adjustmentId, AdjustmentStatus.AdjustmentConfirmed);
        }
    }

    function rejectAdjustment(uint256 adjustmentId) external onlyCouncil {
        AdjustmentCase storage a = adjustmentCases[adjustmentId];
        require(
            a.status == AdjustmentStatus.Filed ||
            a.status == AdjustmentStatus.UnderReview ||
            a.status == AdjustmentStatus.MultiCouncilReview,
            "Invalid status"
        );
        a.status = AdjustmentStatus.Rejected;
        emit AdjustmentStatusChanged(adjustmentId, AdjustmentStatus.Rejected);
    }
}
