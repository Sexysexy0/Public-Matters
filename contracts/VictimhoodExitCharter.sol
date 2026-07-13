// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Victimhood Exit Charter
/// @notice Encodes safeguard for exiting victimhood and mandating proactive rebuilding.
/// @dev Complements ResilienceShiftOracle, ShadowGuardianMandala, and InnovationFreedomCharter.

contract VictimhoodExitCharter {
    address public guardian;
    uint256 public charterCount;
    uint256 public councilCount;

    enum ExitRule {
        VictimhoodExitIsConstitutional,
        ProactiveRebuildingMandated,
        SelfSabotageSuppressed,
        TransparencyInExitSystems,
        PublicBenefitPriority
    }

    enum ExitStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        ExitConfirmed
    }

    struct Rule {
        uint256 id;
        ExitRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct ExitCase {
        uint256 id;
        address proposer;
        string grounds;
        ExitStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => ExitCase) public exitCases;
    mapping(address => bool) public councilMember;

    event RuleDeclared(uint256 indexed id, ExitRule ruleType);
    event RuleLocked(uint256 indexed id);
    event ExitFiled(uint256 indexed id);
    event ExitStatusChanged(uint256 indexed id, ExitStatus status);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        charterCount = 0;
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
        _declare(ExitRule.VictimhoodExitIsConstitutional, "Victimhood exit is constitutional; denial prohibited.");
        _declare(ExitRule.ProactiveRebuildingMandated, "Proactive rebuilding mandated; stagnation blocked.");
        _declare(ExitRule.SelfSabotageSuppressed, "Self-sabotage suppressed; fairness required.");
        _declare(ExitRule.TransparencyInExitSystems, "Exit systems must be transparent.");
        _declare(ExitRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
    }

    function _declare(ExitRule ruleType, string memory description) internal {
        charterCount++;
        rules[charterCount] = Rule(
            charterCount,
            ruleType,
            description,
            false,
            block.timestamp
        );
        emit RuleDeclared(charterCount, ruleType);
    }

    function lockRule(uint256 id) external onlyGuardian {
        Rule storage r = rules[id];
        require(!r.immutableEntry, "Already immutable");
        r.immutableEntry = true;
        emit RuleLocked(id);
    }

    function fileExitCase(string calldata grounds) external {
        charterCount++;
        exitCases[charterCount] = ExitCase(
            charterCount,
            msg.sender,
            grounds,
            ExitStatus.Filed,
            0,
            block.timestamp
        );

        emit ExitFiled(charterCount);
    }

    function beginReview(uint256 exitId) external onlyCouncil {
        ExitCase storage e = exitCases[exitId];
        require(e.status == ExitStatus.Filed, "Not filed");
        e.status = ExitStatus.UnderReview;
        emit ExitStatusChanged(exitId, ExitStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 exitId) external onlyCouncil {
        ExitCase storage e = exitCases[exitId];
        require(e.status == ExitStatus.UnderReview, "Not under review");
        e.status = ExitStatus.MultiCouncilReview;
        emit ExitStatusChanged(exitId, ExitStatus.MultiCouncilReview);
    }

    function confirmExit(uint256 exitId) external onlyCouncil {
        ExitCase storage e = exitCases[exitId];
        require(e.status == ExitStatus.MultiCouncilReview, "Not in council stage");

        e.approvals++;

        if (e.approvals * 2 > councilCount && councilCount > 0) {
            e.status = ExitStatus.ExitConfirmed;
            emit ExitStatusChanged(exitId, ExitStatus.ExitConfirmed);
        }
    }

    function rejectExit(uint256 exitId) external onlyCouncil {
        ExitCase storage e = exitCases[exitId];
        require(
            e.status == ExitStatus.Filed ||
            e.status == ExitStatus.UnderReview ||
            e.status == ExitStatus.MultiCouncilReview,
            "Invalid status"
        );
        e.status = ExitStatus.Rejected;
        emit ExitStatusChanged(exitId, ExitStatus.Rejected);
    }
}
