// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Expedited Procedure Framework
/// @notice Encodes expedited procedure safeguard.
/// @dev Complements AppealsMandala, FreeSpeechMandala, and CaseLawCodification.

contract ExpeditedProcedureFramework {
    address public guardian;
    uint256 public frameworkCount;
    uint256 public councilCount;

    enum ProcedureRule {
        ExpeditedIsConstitutional,
        SpeedMandated,
        DelaySuppressed,
        TransparencyInExpeditedSystems,
        PublicBenefitPriority
    }

    enum ProcedureStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        ExpeditedConfirmed
    }

    struct Rule {
        uint256 id;
        ProcedureRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct ProcedureCase {
        uint256 id;
        address proposer;
        string grounds;
        ProcedureStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => ProcedureCase) public procedures;
    mapping(address => bool) public councilMember;

    event RuleDeclared(uint256 indexed id, ProcedureRule ruleType);
    event RuleLocked(uint256 indexed id);
    event ProcedureFiled(uint256 indexed id);
    event ProcedureStatusChanged(uint256 indexed id, ProcedureStatus status);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        frameworkCount = 0;
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
        _declare(ProcedureRule.ExpeditedIsConstitutional, "Expedited procedure is constitutional; denial prohibited.");
        _declare(ProcedureRule.SpeedMandated, "Speed mandated; delay blocked.");
        _declare(ProcedureRule.DelaySuppressed, "Delay suppressed; fairness required.");
        _declare(ProcedureRule.TransparencyInExpeditedSystems, "Expedited systems must be transparent.");
        _declare(ProcedureRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
    }

    function _declare(ProcedureRule ruleType, string memory description) internal {
        frameworkCount++;
        rules[frameworkCount] = Rule(
            frameworkCount,
            ruleType,
            description,
            false,
            block.timestamp
        );
        emit RuleDeclared(frameworkCount, ruleType);
    }

    function lockRule(uint256 id) external onlyGuardian {
        Rule storage r = rules[id];
        require(!r.immutableEntry, "Already immutable");
        r.immutableEntry = true;
        emit RuleLocked(id);
    }

    function fileProcedureCase(string calldata grounds) external {
        frameworkCount++;
        procedures[frameworkCount] = ProcedureCase(
            frameworkCount,
            msg.sender,
            grounds,
            ProcedureStatus.Filed,
            0,
            block.timestamp
        );

        emit ProcedureFiled(frameworkCount);
    }

    function beginReview(uint256 procedureId) external onlyCouncil {
        ProcedureCase storage p = procedures[procedureId];
        require(p.status == ProcedureStatus.Filed, "Not filed");
        p.status = ProcedureStatus.UnderReview;
        emit ProcedureStatusChanged(procedureId, ProcedureStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 procedureId) external onlyCouncil {
        ProcedureCase storage p = procedures[procedureId];
        require(p.status == ProcedureStatus.UnderReview, "Not under review");
        p.status = ProcedureStatus.MultiCouncilReview;
        emit ProcedureStatusChanged(procedureId, ProcedureStatus.MultiCouncilReview);
    }

    function confirmExpedited(uint256 procedureId) external onlyCouncil {
        ProcedureCase storage p = procedures[procedureId];
        require(p.status == ProcedureStatus.MultiCouncilReview, "Not in council stage");

        p.approvals++;

        if (p.approvals * 2 > councilCount && councilCount > 0) {
            p.status = ProcedureStatus.ExpeditedConfirmed;
            emit ProcedureStatusChanged(procedureId, ProcedureStatus.ExpeditedConfirmed);
        }
    }

    function rejectExpedited(uint256 procedureId) external onlyCouncil {
        ProcedureCase storage p = procedures[procedureId];
        require(
            p.status == ProcedureStatus.Filed ||
            p.status == ProcedureStatus.UnderReview ||
            p.status == ProcedureStatus.MultiCouncilReview,
            "Invalid status"
        );
        p.status = ProcedureStatus.Rejected;
        emit ProcedureStatusChanged(procedureId, ProcedureStatus.Rejected);
    }
}
