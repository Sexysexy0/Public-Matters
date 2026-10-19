// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title PhishingDomainRegistry
 * @notice Canonical registry for suspected phishing, lookalike, and
 *         malicious domains. Downstream mitigation workflows should
 *         reference this registry rather than maintain duplicate domain
 *         state.
 *
 * Lifecycle:
 *   NONE -> SUSPECTED -> CONFIRMED -> MITIGATED | CLEARED | EXPIRED
 */
contract PhishingDomainRegistry {
    enum DomainStatus {
        NONE,
        SUSPECTED,
        CONFIRMED,
        MITIGATED,
        CLEARED,
        EXPIRED
    }

    struct DomainRecord {
        string domain;
        DomainStatus status;
        bytes32 evidenceHash;
        string source;
        uint256 firstSeenAt;
        uint256 lastUpdatedAt;
        uint256 resolvedAt;
        string notes;
    }

    address public governor;
    address public registrar;

    mapping(bytes32 => DomainRecord) private records;
    mapping(bytes32 => bytes32) private domainHashToRecordId;

    bytes32[] private recordIds;

    event DomainRegistered(
        bytes32 indexed recordId, string domain, DomainStatus status, bytes32 evidenceHash, string source
    );

    event DomainStatusChanged(
        bytes32 indexed recordId, string domain, DomainStatus oldStatus, DomainStatus newStatus, string notes
    );

    event GovernorChanged(address indexed previousGovernor, address indexed newGovernor);
    event RegistrarChanged(address indexed previousRegistrar, address indexed newRegistrar);

    error Unauthorized();
    error ZeroAddress();
    error DomainAlreadyRegistered();
    error DomainNotFound();
    error InvalidFinalStatus();
    error AlreadyResolved();

    modifier onlyGovernor() {
        if (msg.sender != governor) revert Unauthorized();
        _;
    }

    modifier onlyRegistrar() {
        if (msg.sender != registrar && msg.sender != governor) revert Unauthorized();
        _;
    }

    constructor() {
        governor = msg.sender;
        registrar = msg.sender;
    }

    function setGovernor(address newGovernor) external onlyGovernor {
        if (newGovernor == address(0)) revert ZeroAddress();
        emit GovernorChanged(governor, newGovernor);
        governor = newGovernor;
    }

    function setRegistrar(address newRegistrar) external onlyGovernor {
        if (newRegistrar == address(0)) revert ZeroAddress();
        emit RegistrarChanged(registrar, newRegistrar);
        registrar = newRegistrar;
    }

    function registerDomain(
        string calldata domain,
        DomainStatus initialStatus,
        bytes32 evidenceHash,
        string calldata source,
        string calldata notes
    ) external onlyRegistrar returns (bytes32 recordId) {
        bytes32 domainKey = keccak256(bytes(domain));
        if (domainHashToRecordId[domainKey] != bytes32(0)) {
            revert DomainAlreadyRegistered();
        }

        recordId = domainKey;

        records[recordId] = DomainRecord({
            domain: domain,
            status: initialStatus,
            evidenceHash: evidenceHash,
            source: source,
            firstSeenAt: block.timestamp,
            lastUpdatedAt: block.timestamp,
            resolvedAt: 0,
            notes: notes
        });

        domainHashToRecordId[domainKey] = recordId;
        recordIds.push(recordId);

        emit DomainRegistered(recordId, domain, initialStatus, evidenceHash, source);
    }

    function updateStatus(bytes32 recordId, DomainStatus newStatus, string calldata notes) external onlyRegistrar {
        DomainRecord storage record = records[recordId];
        if (record.firstSeenAt == 0) revert DomainNotFound();

        DomainStatus oldStatus = record.status;
        record.status = newStatus;
        record.lastUpdatedAt = block.timestamp;
        record.notes = notes;

        emit DomainStatusChanged(recordId, record.domain, oldStatus, newStatus, notes);
    }

    function resolveDomain(bytes32 recordId, DomainStatus finalStatus, string calldata notes) external onlyGovernor {
        DomainRecord storage record = records[recordId];
        if (record.firstSeenAt == 0) revert DomainNotFound();
        if (record.resolvedAt != 0) revert AlreadyResolved();

        if (
            finalStatus != DomainStatus.MITIGATED && finalStatus != DomainStatus.CLEARED
                && finalStatus != DomainStatus.EXPIRED
        ) {
            revert InvalidFinalStatus();
        }

        DomainStatus oldStatus = record.status;
        record.status = finalStatus;
        record.resolvedAt = block.timestamp;
        record.lastUpdatedAt = block.timestamp;
        record.notes = notes;

        emit DomainStatusChanged(recordId, record.domain, oldStatus, finalStatus, notes);
    }

    function getRecord(bytes32 recordId) external view returns (DomainRecord memory) {
        return records[recordId];
    }

    function getRecordIdByDomain(string calldata domain) external view returns (bytes32) {
        return domainHashToRecordId[keccak256(bytes(domain))];
    }

    function totalRecords() external view returns (uint256) {
        return recordIds.length;
    }

    function getAllRecordIds() external view returns (bytes32[] memory) {
        return recordIds;
    }
}
