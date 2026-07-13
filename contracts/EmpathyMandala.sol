// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Empathy Mandala
/// @notice Encodes empathy resonance safeguard.
/// @dev Complements KindnessFramework, CareTreaty, and CompassionFramework.

contract EmpathyMandala {
    address public guardian;
    uint256 public mandalaCount;
    uint256 public councilCount;

    enum EmpathyRule {
        EmpathyIsConstitutional,
        ResonanceMandated,
        ApathySuppressed,
        TransparencyInEmpathySystems,
        PublicBenefitPriority
    }

    enum EmpathyStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        EmpathyConfirmed
    }

    struct Rule {
        uint256 id;
        EmpathyRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct EmpathyCase {
        uint256 id;
        address proposer;
        string grounds;
        EmpathyStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => EmpathyCase) public empathyCases;
    mapping(address => bool) public councilMember;

    event RuleDeclared(uint256 indexed id, EmpathyRule ruleType);
    event RuleLocked(uint256 indexed id);
    event EmpathyFiled(uint256 indexed id);
    event EmpathyStatusChanged(uint256 indexed id, EmpathyStatus status);
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
        _declare(EmpathyRule.EmpathyIsConstitutional, "Empathy is constitutional; denial prohibited.");
        _declare(EmpathyRule.ResonanceMandated, "Resonance mandated; apathy blocked.");
        _declare(EmpathyRule.ApathySuppressed, "Apathy suppressed; fairness required.");
        _declare(EmpathyRule.TransparencyInEmpathySystems, "Empathy systems must be transparent.");
        _declare(EmpathyRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
    }

    function _declare(EmpathyRule ruleType, string memory description) internal {
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

    function fileEmpathyCase(string calldata grounds) external {
        mandalaCount++;
        empathyCases[mandalaCount] = EmpathyCase(
            mandalaCount,
            msg.sender,
            grounds,
            EmpathyStatus.Filed,
            0,
            block.timestamp
        );

        emit EmpathyFiled(mandalaCount);
    }

    function beginReview(uint256 empathyId) external onlyCouncil {
        EmpathyCase storage e = empathyCases[empathyId];
        require(e.status == EmpathyStatus.Filed, "Not filed");
        e.status = EmpathyStatus.UnderReview;
        emit EmpathyStatusChanged(empathyId, EmpathyStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 empathyId) external onlyCouncil {
        EmpathyCase storage e = empathyCases[empathyId];
        require(e.status == EmpathyStatus.UnderReview, "Not under review");
        e.status = EmpathyStatus.MultiCouncilReview;
        emit EmpathyStatusChanged(empathyId, EmpathyStatus.MultiCouncilReview);
    }

    function confirmEmpathy(uint256 empathyId) external onlyCouncil {
        EmpathyCase storage e = empathyCases[empathyId];
        require(e.status == EmpathyStatus.MultiCouncilReview, "Not in council stage");

        e.approvals++;

        if (e.approvals * 2 > councilCount && councilCount > 0) {
            e.status = EmpathyStatus.EmpathyConfirmed;
            emit EmpathyStatusChanged(empathyId, EmpathyStatus.EmpathyConfirmed);
        }
    }

    function rejectEmpathy(uint256 empathyId) external onlyCouncil {
        EmpathyCase storage e = empathyCases[empathyId];
        require(
            e.status == EmpathyStatus.Filed ||
            e.status == EmpathyStatus.UnderReview ||
            e.status == EmpathyStatus.MultiCouncilReview,
            "Invalid status"
        );
        e.status = EmpathyStatus.Rejected;
        emit EmpathyStatusChanged(empathyId, EmpathyStatus.Rejected);
    }
}
