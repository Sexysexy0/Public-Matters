// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Crisis Leadership Framework
/// @notice Establishes calm, structured, and transparent decision-making protocols during crises.
/// @dev Works with TransparencyCulture and ReputationRiskProtocol to prevent panic-driven governance failures.

contract CrisisLeadershipFramework {
    address public guardian;
    uint256 public protocolCount;
    uint256 public crisisCount;
    uint256 public councilCount;

    enum RoleType {
        Leader,
        Founder,
        CrisisTeam,
        Council,
        Oversight,
        PublicServant,
        Innovator
    }

    enum CrisisProtocol {
        MandatoryCalmPeriod,
        MandatoryRootCauseAnalysis,
        MandatoryMultiCouncilApproval,
        MandatoryPublicClarification,
        NoPanicReactions,
        NoRetaliatoryActions,
        NoNarrativeManipulation,
        TransparencyOverSuppression,
        ReputationProtectionOverEgo,
        CrisisLearningPublication
    }

    enum CrisisViolation {
        PanicReaction,
        RetaliatoryAction,
        NarrativeManipulation,
        SuppressionAttempt,
        EgoDrivenDecision,
        TransparencyFailure,
        RootCauseIgnored,
        CouncilBypassed,
        ClarificationFailure
    }

    enum CrisisStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        ConfirmedViolation
    }

    struct Protocol {
        uint256 id;
        CrisisProtocol protocolType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct CrisisCase {
        uint256 id;
        address accuser;
        address accused;
        CrisisViolation violationType;
        string details;
        CrisisStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Protocol) public protocols;
    mapping(uint256 => CrisisCase) public crises;
    mapping(address => RoleType) public roles;
    mapping(address => bool) public councilMember;

    event ProtocolDeclared(uint256 indexed id, CrisisProtocol protocolType);
    event ProtocolLocked(uint256 indexed id);
    event CrisisFiled(uint256 indexed id, CrisisViolation violationType);
    event CrisisStatusChanged(uint256 indexed id, CrisisStatus status);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        protocolCount = 0;
        crisisCount = 0;
        councilCount = 0;

        _declareDefaultProtocols();
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

    function _declareDefaultProtocols() internal {
        _declare(CrisisProtocol.MandatoryCalmPeriod, "Leaders must observe a calm period before acting.");
        _declare(CrisisProtocol.MandatoryRootCauseAnalysis, "Root cause analysis is mandatory.");
        _declare(CrisisProtocol.MandatoryMultiCouncilApproval, "Multi-council approval required for crisis actions.");
        _declare(CrisisProtocol.MandatoryPublicClarification, "Public clarification is mandatory after crisis decisions.");
        _declare(CrisisProtocol.NoPanicReactions, "Panic-driven reactions are prohibited.");
        _declare(CrisisProtocol.NoRetaliatoryActions, "Retaliatory actions are prohibited.");
        _declare(CrisisProtocol.NoNarrativeManipulation, "Narrative manipulation is prohibited.");
        _declare(CrisisProtocol.TransparencyOverSuppression, "Transparency overrides suppression attempts.");
        _declare(CrisisProtocol.ReputationProtectionOverEgo, "Reputation protection overrides ego-driven decisions.");
        _declare(CrisisProtocol.CrisisLearningPublication, "Crisis learnings must be published for future prevention.");
    }

    function _declare(CrisisProtocol protocolType, string memory description) internal {
        protocolCount++;
        protocols[protocolCount] = Protocol(
            protocolCount,
            protocolType,
            description,
            false,
            block.timestamp
        );
        emit ProtocolDeclared(protocolCount, protocolType);
    }

    function lockProtocol(uint256 id) external onlyGuardian {
        Protocol storage p = protocols[id];
        require(!p.immutableEntry, "Already immutable");
        p.immutableEntry = true;
        emit ProtocolLocked(id);
    }

    function fileCrisis(
        address accused,
        CrisisViolation violationType,
        string calldata details
    ) external {
        crisisCount++;
        crises[crisisCount] = CrisisCase(
            crisisCount,
            msg.sender,
            accused,
            violationType,
            details,
            CrisisStatus.Filed,
            0,
            block.timestamp
        );

        emit CrisisFiled(crisisCount, violationType);
    }

    function beginReview(uint256 crisisId) external onlyCouncil {
        CrisisCase storage c = crises[crisisId];
        require(c.status == CrisisStatus.Filed, "Not filed");
        c.status = CrisisStatus.UnderReview;
        emit CrisisStatusChanged(crisisId, CrisisStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 crisisId) external onlyCouncil {
        CrisisCase storage c = crises[crisisId];
        require(c.status == CrisisStatus.UnderReview, "Not under review");
        c.status = CrisisStatus.MultiCouncilReview;
        emit CrisisStatusChanged(crisisId, CrisisStatus.MultiCouncilReview);
    }

    function approveViolation(uint256 crisisId) external onlyCouncil {
        CrisisCase storage c = crises[crisisId];
        require(c.status == CrisisStatus.MultiCouncilReview, "Not in council stage");

        c.approvals++;

        if (c.approvals * 2 > councilCount && councilCount > 0) {
            c.status = CrisisStatus.ConfirmedViolation;
            emit CrisisStatusChanged(crisisId, CrisisStatus.ConfirmedViolation);
        }
    }

    function rejectCrisis(uint256 crisisId) external onlyCouncil {
        CrisisCase storage c = crises[crisisId];
        require(
            c.status == CrisisStatus.Filed ||
            c.status == CrisisStatus.UnderReview ||
            c.status == CrisisStatus.MultiCouncilReview,
            "Invalid status"
        );
        c.status = CrisisStatus.Rejected;
        emit CrisisStatusChanged(crisisId, CrisisStatus.Rejected);
    }
}
