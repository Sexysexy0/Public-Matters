// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {PhishingDomainRegistry} from "./PhishingDomainRegistry.sol";

/**
 * @title ThreatMitigationPhase2
 * @notice Tracks lookalike-domain mitigation from detection to resolution.
 *
 * A domain must already exist in the canonical PhishingDomainRegistry before
 * a mitigation case can be logged. This contract tracks only the mitigation
 * workflow; the registry remains the source of truth for domain status.
 *
 * Lifecycle:
 *   DETECTED -> TAKEDOWN_REQUESTED -> TAKEDOWN_IN_PROGRESS
 *            -> TAKEDOWN_COMPLETED | TAKEDOWN_FAILED | ESCALATED
 */
contract ThreatMitigationPhase2 {
    enum DomainStatus {
        DETECTED,
        TAKEDOWN_REQUESTED,
        TAKEDOWN_IN_PROGRESS,
        TAKEDOWN_COMPLETED,
        TAKEDOWN_FAILED,
        ESCALATED
    }

    enum Severity {
        LOW,
        MEDIUM,
        HIGH,
        CRITICAL
    }

    struct DomainThreat {
        bytes32 id;
        bytes32 registryRecordId;
        string domainName;
        string registrar;
        string registrarCaseId;
        Severity severity;
        DomainStatus status;
        bytes32 evidenceHash;
        uint256 detectedAt;
        uint256 lastUpdatedAt;
        uint256 resolvedAt;
        string resolutionNotes;
    }

    address public governor;
    address public logger;
    PhishingDomainRegistry public immutable domainRegistry;

    mapping(bytes32 => DomainThreat) private threats;
    bytes32[] private threatIds;
    mapping(DomainStatus => uint256) private countByStatus;

    event DomainThreatLogged(
        bytes32 indexed id,
        bytes32 indexed registryRecordId,
        string domainName,
        string registrar,
        Severity severity,
        bytes32 evidenceHash
    );

    event DomainStatusChanged(bytes32 indexed id, DomainStatus oldStatus, DomainStatus newStatus, string notes);

    event DomainResolved(bytes32 indexed id, DomainStatus finalStatus, uint256 resolvedAt, string notes);

    event GovernorChanged(address indexed oldGovernor, address indexed newGovernor);
    event LoggerChanged(address indexed oldLogger, address indexed newLogger);

    error Unauthorized();
    error ZeroAddress();
    error ThreatAlreadyLogged();
    error ThreatNotFound();
    error InvalidFinalStatus();
    error AlreadyResolved();
    error DomainNotRegistered();

    modifier onlyGovernor() {
        if (msg.sender != governor) revert Unauthorized();
        _;
    }

    modifier onlyLogger() {
        if (msg.sender != logger && msg.sender != governor) revert Unauthorized();
        _;
    }

    modifier threatExists(bytes32 id) {
        if (threats[id].detectedAt == 0) revert ThreatNotFound();
        _;
    }

    constructor(address registryAddress) {
        if (registryAddress == address(0)) revert ZeroAddress();

        governor = msg.sender;
        logger = msg.sender;
        domainRegistry = PhishingDomainRegistry(registryAddress);
    }

    function setGovernor(address newGovernor) external onlyGovernor {
        if (newGovernor == address(0)) revert ZeroAddress();
        emit GovernorChanged(governor, newGovernor);
        governor = newGovernor;
    }

    function setLogger(address newLogger) external onlyGovernor {
        if (newLogger == address(0)) revert ZeroAddress();
        emit LoggerChanged(logger, newLogger);
        logger = newLogger;
    }

    function logDomainThreat(
        bytes32 id,
        string calldata domainName,
        string calldata registrar,
        Severity severity,
        bytes32 evidenceHash
    ) external onlyLogger returns (bytes32 registryRecordId) {
        if (threats[id].detectedAt != 0) revert ThreatAlreadyLogged();

        registryRecordId = domainRegistry.getRecordIdByDomain(domainName);
        if (registryRecordId == bytes32(0)) revert DomainNotRegistered();

        threats[id] = DomainThreat({
            id: id,
            registryRecordId: registryRecordId,
            domainName: domainName,
            registrar: registrar,
            registrarCaseId: "",
            severity: severity,
            status: DomainStatus.DETECTED,
            evidenceHash: evidenceHash,
            detectedAt: block.timestamp,
            lastUpdatedAt: block.timestamp,
            resolvedAt: 0,
            resolutionNotes: ""
        });

        threatIds.push(id);
        countByStatus[DomainStatus.DETECTED]++;

        emit DomainThreatLogged(id, registryRecordId, domainName, registrar, severity, evidenceHash);
    }

    function updateStatus(bytes32 id, DomainStatus newStatus, string calldata registrarCaseId, string calldata notes)
        external
        onlyLogger
        threatExists(id)
    {
        DomainThreat storage threat = threats[id];
        DomainStatus oldStatus = threat.status;

        if (newStatus == DomainStatus.TAKEDOWN_COMPLETED) {
            revert InvalidFinalStatus();
        }

        countByStatus[oldStatus]--;
        countByStatus[newStatus]++;
        threat.status = newStatus;
        threat.lastUpdatedAt = block.timestamp;

        if (bytes(registrarCaseId).length > 0) {
            threat.registrarCaseId = registrarCaseId;
        }

        emit DomainStatusChanged(id, oldStatus, newStatus, notes);
    }

    function resolve(bytes32 id, DomainStatus finalStatus, string calldata notes)
        external
        onlyGovernor
        threatExists(id)
    {
        if (
            finalStatus != DomainStatus.TAKEDOWN_COMPLETED && finalStatus != DomainStatus.TAKEDOWN_FAILED
                && finalStatus != DomainStatus.ESCALATED
        ) {
            revert InvalidFinalStatus();
        }

        DomainThreat storage threat = threats[id];
        if (threat.resolvedAt != 0) revert AlreadyResolved();

        DomainStatus oldStatus = threat.status;

        countByStatus[oldStatus]--;
        countByStatus[finalStatus]++;
        threat.status = finalStatus;
        threat.resolvedAt = block.timestamp;
        threat.lastUpdatedAt = block.timestamp;
        threat.resolutionNotes = notes;

        emit DomainResolved(id, finalStatus, block.timestamp, notes);
    }

    function getThreat(bytes32 id) external view threatExists(id) returns (DomainThreat memory) {
        return threats[id];
    }

    function getAllThreatIds() external view returns (bytes32[] memory) {
        return threatIds;
    }

    function totalThreats() external view returns (uint256) {
        return threatIds.length;
    }

    function activeCount() external view returns (uint256) {
        return countByStatus[DomainStatus.DETECTED] + countByStatus[DomainStatus.TAKEDOWN_REQUESTED]
            + countByStatus[DomainStatus.TAKEDOWN_IN_PROGRESS];
    }

    function countByStatusValue(DomainStatus status) external view returns (uint256) {
        return countByStatus[status];
    }
}
