// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Compassion Framework
/// @notice Encodes compassion safeguard.
/// @dev Complements CareTreaty, EmpathyMandala, and KindnessFramework.

contract CompassionFramework {
    address public guardian;
    uint256 public compassionCount;
    uint256 public councilCount;

    enum CompassionRule {
        CompassionIsConstitutional,
        MercyMandated,
        HarshnessSuppressed,
        TransparencyInCompassionSystems,
        PublicBenefitPriority
    }

    enum CompassionStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        CompassionConfirmed
    }

    struct Rule {
        uint256 id;
        CompassionRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct CompassionCase {
        uint256 id;
        address proposer;
        string grounds;
        CompassionStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => CompassionCase) public compassionCases;
    mapping(address => bool) public councilMember;

    event RuleDeclared(uint256 indexed id, CompassionRule ruleType);
    event RuleLocked(uint256 indexed id);
    event CompassionFiled(uint256 indexed id);
    event CompassionStatusChanged(uint256 indexed id, CompassionStatus status);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        compassionCount = 0;
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
        _declare(CompassionRule.CompassionIsConstitutional, "Compassion is constitutional; denial prohibited.");
        _declare(CompassionRule.MercyMandated, "Mercy mandated; harshness blocked.");
        _declare(CompassionRule.HarshnessSuppressed, "Harshness suppressed; fairness required.");
        _declare(CompassionRule.TransparencyInCompassionSystems, "Compassion systems must be transparent.");
        _declare(CompassionRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
    }

    function _declare(CompassionRule ruleType, string memory description) internal {
        compassionCount++;
        rules[compassionCount] = Rule(
            compassionCount,
            ruleType,
            description,
            false,
            block.timestamp
        );
        emit RuleDeclared(compassionCount, ruleType);
    }

    function lockRule(uint256 id) external onlyGuardian {
        Rule storage r = rules[id];
        require(!r.immutableEntry, "Already immutable");
        r.immutableEntry = true;
        emit RuleLocked(id);
    }

    function fileCompassionCase(string calldata grounds) external {
        compassionCount++;
        compassionCases[compassionCount] = CompassionCase(
            compassionCount,
            msg.sender,
            grounds,
            CompassionStatus.Filed,
            0,
            block.timestamp
        );

        emit CompassionFiled(compassionCount);
    }

    function beginReview(uint256 compassionId) external onlyCouncil {
        CompassionCase storage c = compassionCases[compassionId];
        require(c.status == CompassionStatus.Filed, "Not filed");
        c.status = CompassionStatus.UnderReview;
        emit CompassionStatusChanged(compassionId, CompassionStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 compassionId) external onlyCouncil {
        CompassionCase storage c = compassionCases[compassionId];
        require(c.status == CompassionStatus.UnderReview, "Not under review");
        c.status = CompassionStatus.MultiCouncilReview;
        emit CompassionStatusChanged(compassionId, CompassionStatus.MultiCouncilReview);
    }

    function confirmCompassion(uint256 compassionId) external onlyCouncil {
        CompassionCase storage c = compassionCases[compassionId];
        require(c.status == CompassionStatus.MultiCouncilReview, "Not in council stage");

        c.approvals++;

        if (c.approvals * 2 > councilCount && councilCount > 0) {
            c.status = CompassionStatus.CompassionConfirmed;
            emit CompassionStatusChanged(compassionId, CompassionStatus.CompassionConfirmed);
        }
    }

    function rejectCompassion(uint256 compassionId) external onlyCouncil {
        CompassionCase storage c = compassionCases[compassionId];
        require(
            c.status == CompassionStatus.Filed ||
            c.status == CompassionStatus.UnderReview ||
            c.status == CompassionStatus.MultiCouncilReview,
            "Invalid status"
        );
        c.status = CompassionStatus.Rejected;
        emit CompassionStatusChanged(compassionId, CompassionStatus.Rejected);
    }
}
