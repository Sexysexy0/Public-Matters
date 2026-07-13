// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Resilience Shift Oracle
/// @notice Encodes safeguard for systemic resilience triggered by 8-hour shifts.
/// @dev Complements ShadowGuardianMandala, BioReconstructionMandala, and RiskContextReview.

contract ResilienceShiftOracle {
    address public guardian;
    uint256 public oracleCount;
    uint256 public councilCount;

    enum ShiftRule {
        ResilienceShiftIsConstitutional,
        EightHourTriggerMandated,
        SuppressionOfCollapse,
        TransparencyInShiftSystems,
        PublicBenefitPriority
    }

    enum ShiftStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        ShiftConfirmed
    }

    struct Rule {
        uint256 id;
        ShiftRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct ShiftCase {
        uint256 id;
        address proposer;
        string grounds;
        ShiftStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => ShiftCase) public shiftCases;
    mapping(address => bool) public councilMember;

    event RuleDeclared(uint256 indexed id, ShiftRule ruleType);
    event RuleLocked(uint256 indexed id);
    event ShiftFiled(uint256 indexed id);
    event ShiftStatusChanged(uint256 indexed id, ShiftStatus status);
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
        _declare(ShiftRule.ResilienceShiftIsConstitutional, "Resilience shift is constitutional; denial prohibited.");
        _declare(ShiftRule.EightHourTriggerMandated, "Eight-hour trigger mandated; resilience activated.");
        _declare(ShiftRule.SuppressionOfCollapse, "Collapse suppressed; fairness required.");
        _declare(ShiftRule.TransparencyInShiftSystems, "Shift systems must be transparent.");
        _declare(ShiftRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
    }

    function _declare(ShiftRule ruleType, string memory description) internal {
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

    function fileShiftCase(string calldata grounds) external {
        oracleCount++;
        shiftCases[oracleCount] = ShiftCase(
            oracleCount,
            msg.sender,
            grounds,
            ShiftStatus.Filed,
            0,
            block.timestamp
        );

        emit ShiftFiled(oracleCount);
    }

    function beginReview(uint256 shiftId) external onlyCouncil {
        ShiftCase storage s = shiftCases[shiftId];
        require(s.status == ShiftStatus.Filed, "Not filed");
        s.status = ShiftStatus.UnderReview;
        emit ShiftStatusChanged(shiftId, ShiftStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 shiftId) external onlyCouncil {
        ShiftCase storage s = shiftCases[shiftId];
        require(s.status == ShiftStatus.UnderReview, "Not under review");
        s.status = ShiftStatus.MultiCouncilReview;
        emit ShiftStatusChanged(shiftId, ShiftStatus.MultiCouncilReview);
    }

    function confirmShift(uint256 shiftId) external onlyCouncil {
        ShiftCase storage s = shiftCases[shiftId];
        require(s.status == ShiftStatus.MultiCouncilReview, "Not in council stage");

        s.approvals++;

        if (s.approvals * 2 > councilCount && councilCount > 0) {
            s.status = ShiftStatus.ShiftConfirmed;
            emit ShiftStatusChanged(shiftId, ShiftStatus.ShiftConfirmed);
        }
    }

    function rejectShift(uint256 shiftId) external onlyCouncil {
        ShiftCase storage s = shiftCases[shiftId];
        require(
            s.status == ShiftStatus.Filed ||
            s.status == ShiftStatus.UnderReview ||
            s.status == ShiftStatus.MultiCouncilReview,
            "Invalid status"
        );
        s.status = ShiftStatus.Rejected;
        emit ShiftStatusChanged(shiftId, ShiftStatus.Rejected);
    }
}
