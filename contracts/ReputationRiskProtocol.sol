// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Reputation Risk Protocol
/// @notice Prevents leaders, founders, and organizations from making panic-driven decisions that damage public trust.
/// @dev Works with LeadershipAntiCensorshipCharter to enforce calm, transparent, non-retaliatory reputation management.

contract ReputationRiskProtocol {
    address public guardian;
    uint256 public ruleCount;
    uint256 public incidentCount;
    uint256 public councilCount;

    enum RoleType {
        Leader,
        Founder,
        Creator,
        PublicFigure,
        Council,
        Oversight,
        CrisisTeam
    }

    enum RiskRule {
        NoPanicReactions,
        NoDMCAWeaponization,
        NoRetaliatoryStrikes,
        NoNarrativeManipulation,
        MandatoryCalmPeriod,
        MandatoryRootCauseAnalysis,
        MandatoryPublicClarification,
        TransparencyOverSuppression,
        CriticismIsData,
        ReputationProtectionOverEgo
    }

    enum IncidentType {
        PanicReaction,
        DMCAWeaponization,
        RetaliatoryAction,
        NarrativeManipulation,
        SuppressionAttempt,
        IgnoredRootCause,
        TransparencyFailure,
        EgoDrivenDecision
    }

    enum IncidentStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        ConfirmedRiskViolation
    }

    struct Rule {
        uint256 id;
        RiskRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct Incident {
        uint256 id;
        address reporter;
        address actor;
        IncidentType incidentType;
        string details;
        IncidentStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => Incident) public incidents;
    mapping(address => RoleType) public roles;
    mapping(address => bool) public councilMember;

    event RuleDeclared(uint256 indexed id, RiskRule ruleType);
    event RuleLocked(uint256 indexed id);
    event IncidentFiled(uint256 indexed id, IncidentType incidentType);
    event IncidentStatusChanged(uint256 indexed id, IncidentStatus status);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        ruleCount = 0;
        incidentCount = 0;
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

    function _declareDefaultRules() internal {
        _declareRule(RiskRule.NoPanicReactions, "Leaders cannot make panic-driven decisions.");
        _declareRule(RiskRule.NoDMCAWeaponization, "DMCA cannot be used to silence criticism.");
        _declareRule(RiskRule.NoRetaliatoryStrikes, "Retaliation against commentary is prohibited.");
        _declareRule(RiskRule.NoNarrativeManipulation, "Narrative manipulation is prohibited.");
        _declareRule(RiskRule.MandatoryCalmPeriod, "A calm period is required before any public action.");
        _declareRule(RiskRule.MandatoryRootCauseAnalysis, "Root cause analysis is mandatory.");
        _declareRule(RiskRule.MandatoryPublicClarification, "Public clarification is required after incidents.");
        _declareRule(RiskRule.TransparencyOverSuppression, "Transparency is preferred over suppression.");
        _declareRule(RiskRule.CriticismIsData, "Criticism is diagnostic data, not an attack.");
        _declareRule(RiskRule.ReputationProtectionOverEgo, "Reputation protection is prioritized over ego.");
    }

    function _declareRule(RiskRule ruleType, string memory description) internal {
        ruleCount++;
        rules[ruleCount] = Rule(
            ruleCount,
            ruleType,
            description,
            false,
            block.timestamp
        );
        emit RuleDeclared(ruleCount, ruleType);
    }

    function lockRule(uint256 id) external onlyGuardian {
        Rule storage r = rules[id];
        require(!r.immutableEntry, "Already immutable");
        r.immutableEntry = true;
        emit RuleLocked(id);
    }

    function fileIncident(
        address actor,
        IncidentType incidentType,
        string calldata details
    ) external {
        incidentCount++;
        incidents[incidentCount] = Incident(
            incidentCount,
            msg.sender,
            actor,
            incidentType,
            details,
            IncidentStatus.Filed,
            0,
            block.timestamp
        );

        emit IncidentFiled(incidentCount, incidentType);
    }

    function beginReview(uint256 incidentId) external onlyCouncil {
        Incident storage i = incidents[incidentId];
        require(i.status == IncidentStatus.Filed, "Not filed");
        i.status = IncidentStatus.UnderReview;
        emit IncidentStatusChanged(incidentId, IncidentStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 incidentId) external onlyCouncil {
        Incident storage i = incidents[incidentId];
        require(i.status == IncidentStatus.UnderReview, "Not under review");
        i.status = IncidentStatus.MultiCouncilReview;
        emit IncidentStatusChanged(incidentId, IncidentStatus.MultiCouncilReview);
    }

    function approveViolation(uint256 incidentId) external onlyCouncil {
        Incident storage i = incidents[incidentId];
        require(i.status == IncidentStatus.MultiCouncilReview, "Not in council stage");

        i.approvals++;

        if (i.approvals * 2 > councilCount && councilCount > 0) {
            i.status = IncidentStatus.ConfirmedRiskViolation;
            emit IncidentStatusChanged(incidentId, IncidentStatus.ConfirmedRiskViolation);
        }
    }

    function rejectIncident(uint256 incidentId) external onlyCouncil {
        Incident storage i = incidents[incidentId];
        require(
            i.status == IncidentStatus.Filed ||
            i.status == IncidentStatus.UnderReview ||
            i.status == IncidentStatus.MultiCouncilReview,
            "Invalid status"
        );
        i.status = IncidentStatus.Rejected;
        emit IncidentStatusChanged(incidentId, IncidentStatus.Rejected);
    }
}
