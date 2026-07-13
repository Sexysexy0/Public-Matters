// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Crisis Energy Framework
/// @notice Emergency protocol for energy shocks, ensuring resilience, rapid response, and public benefit prioritization.
/// @dev Complements EnergyResilienceCovenant and TradeFairnessCharter.

contract CrisisEnergyFramework {
    address public guardian;
    uint256 public protocolCount;
    uint256 public violationCount;
    uint256 public councilCount;

    enum CrisisRule {
        MandatoryEmergencyDiversification,
        MandatoryPublicLedgerEntry,
        MandatoryCouncilOversight,
        PublicBenefitPriority,
        TransparencyOverSecrecy,
        CrisisResilienceIsConstitutional
    }

    enum ViolationType {
        DiversificationFailure,
        LedgerBypass,
        CouncilBypass,
        PublicBenefitErasure,
        TransparencyFailure,
        CrisisMismanagement
    }

    enum CaseStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        ConfirmedViolation
    }

    struct Protocol {
        uint256 id;
        CrisisRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct Violation {
        uint256 id;
        address accuser;
        address accused;
        ViolationType violationType;
        string details;
        CaseStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Protocol) public protocols;
    mapping(uint256 => Violation) public violations;
    mapping(address => bool) public councilMember;

    event ProtocolDeclared(uint256 indexed id, CrisisRule ruleType);
    event ProtocolLocked(uint256 indexed id);
    event ViolationFiled(uint256 indexed id, ViolationType violationType);
    event CaseStatusChanged(uint256 indexed id, CaseStatus status);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        protocolCount = 0;
        violationCount = 0;
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
        _declare(CrisisRule.MandatoryEmergencyDiversification, "Energy sources must be diversified during crisis.");
        _declare(CrisisRule.MandatoryPublicLedgerEntry, "All crisis energy contracts must be logged.");
        _declare(CrisisRule.MandatoryCouncilOversight, "Council oversight required for emergency energy deals.");
        _declare(CrisisRule.PublicBenefitPriority, "Public benefit overrides private speculation in crisis.");
        _declare(CrisisRule.TransparencyOverSecrecy, "Transparency overrides secrecy in crisis energy systems.");
        _declare(CrisisRule.CrisisResilienceIsConstitutional, "Crisis resilience is constitutional.");
    }

    function _declare(CrisisRule ruleType, string memory description) internal {
        protocolCount++;
        protocols[protocolCount] = Protocol(
            protocolCount,
            ruleType,
            description,
            false,
            block.timestamp
        );
        emit ProtocolDeclared(protocolCount, ruleType);
    }

    function lockProtocol(uint256 id) external onlyGuardian {
        Protocol storage p = protocols[id];
        require(!p.immutableEntry, "Already immutable");
        p.immutableEntry = true;
        emit ProtocolLocked(id);
    }

    function fileViolation(
        address accused,
        ViolationType violationType,
        string calldata details
    ) external {
        violationCount++;
        violations[violationCount] = Violation(
            violationCount,
            msg.sender,
            accused,
            violationType,
            details,
            CaseStatus.Filed,
            0,
            block.timestamp
        );

        emit ViolationFiled(violationCount, violationType);
    }

    function beginReview(uint256 violationId) external onlyCouncil {
        Violation storage v = violations[violationId];
        require(v.status == CaseStatus.Filed, "Not filed");
        v.status = CaseStatus.UnderReview;
        emit CaseStatusChanged(violationId, CaseStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 violationId) external onlyCouncil {
        Violation storage v = violations[violationId];
        require(v.status == CaseStatus.UnderReview, "Not under review");
        v.status = CaseStatus.MultiCouncilReview;
        emit CaseStatusChanged(violationId, CaseStatus.MultiCouncilReview);
    }

    function approveViolation(uint256 violationId) external onlyCouncil {
        Violation storage v = violations[violationId];
        require(v.status == CaseStatus.MultiCouncilReview, "Not in council stage");

        v.approvals++;

        if (v.approvals * 2 > councilCount && councilCount > 0) {
            v.status = CaseStatus.ConfirmedViolation;
            emit CaseStatusChanged(violationId, CaseStatus.ConfirmedViolation);
        }
    }

    function rejectViolation(uint256 violationId) external onlyCouncil {
        Violation storage v = violations[violationId];
        require(
            v.status == CaseStatus.Filed ||
            v.status == CaseStatus.UnderReview ||
            v.status == CaseStatus.MultiCouncilReview,
            "Invalid status"
        );
        v.status = CaseStatus.Rejected;
        emit CaseStatusChanged(violationId, CaseStatus.Rejected);
    }
}
