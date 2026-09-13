// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract NuclearPublicAudit {
    struct AuditEntry {
        bytes32 subject;
        bytes32 action;
        bytes32 payloadHash;
        bytes32 previousEntryHash;
        address actor;
        uint64 createdAt;
        bool frozen;
    }

    error Unauthorized();
    error InvalidInput();
    error AlreadyExists();
    error MissingEntry();
    error FrozenEntry();

    address public owner;
    mapping(address => bool) public auditors;
    mapping(bytes32 => AuditEntry) private entries;
    mapping(bytes32 => bytes32) public latestEntryBySubject;

    event AuditorUpdated(address indexed auditor, bool authorized);
    event AuditEntryLogged(
        bytes32 indexed entryId,
        bytes32 indexed subject,
        bytes32 indexed action,
        bytes32 payloadHash,
        bytes32 previousEntryHash,
        address actor
    );
    event AuditEntryFrozen(bytes32 indexed entryId);
    event AuditEntrySuperseded(
        bytes32 indexed previousEntryId,
        bytes32 indexed replacementEntryId
    );

    modifier onlyOwner() {
        if (msg.sender != owner) revert Unauthorized();
        _;
    }

    modifier onlyAuditor() {
        if (!auditors[msg.sender]) revert Unauthorized();
        _;
    }

    constructor() {
        owner = msg.sender;
        auditors[msg.sender] = true;
        emit AuditorUpdated(msg.sender, true);
    }

    function setAuditor(address auditor, bool authorized) external onlyOwner {
        if (auditor == address(0)) revert InvalidInput();
        auditors[auditor] = authorized;
        emit AuditorUpdated(auditor, authorized);
    }

    function logEntry(
        bytes32 entryId,
        bytes32 subject,
        bytes32 action,
        bytes32 payloadHash
    ) external onlyAuditor {
        _logEntry(entryId, subject, action, payloadHash, msg.sender);
    }

    function _logEntry(
        bytes32 entryId,
        bytes32 subject,
        bytes32 action,
        bytes32 payloadHash,
        address actor
    ) internal {
        if (
            entryId == bytes32(0) ||
            subject == bytes32(0) ||
            action == bytes32(0) ||
            payloadHash == bytes32(0)
        ) {
            revert InvalidInput();
        }
        if (entries[entryId].createdAt != 0) revert AlreadyExists();

        bytes32 previousEntryId = latestEntryBySubject[subject];
        bytes32 previousEntryHash;

        if (previousEntryId != bytes32(0)) {
            previousEntryHash = keccak256(
                abi.encode(previousEntryId, entries[previousEntryId])
            );
        }

        entries[entryId] = AuditEntry({
            subject: subject,
            action: action,
            payloadHash: payloadHash,
            previousEntryHash: previousEntryHash,
            actor: actor,
            createdAt: uint64(block.timestamp),
            frozen: false
        });

        latestEntryBySubject[subject] = entryId;

        emit AuditEntryLogged(
            entryId,
            subject,
            action,
            payloadHash,
            previousEntryHash,
            actor
        );
    }

    function supersedeEntry(
        bytes32 previousEntryId,
        bytes32 replacementEntryId,
        bytes32 action,
        bytes32 payloadHash
    ) external onlyAuditor {
        AuditEntry storage previous = entries[previousEntryId];
        if (previous.createdAt == 0) revert MissingEntry();
        if (previous.frozen) revert FrozenEntry();

        _logEntry(
            replacementEntryId,
            previous.subject,
            action,
            payloadHash,
            msg.sender
        );

        emit AuditEntrySuperseded(previousEntryId, replacementEntryId);
    }

    function freezeEntry(bytes32 entryId) external onlyOwner {
        AuditEntry storage entry = entries[entryId];
        if (entry.createdAt == 0) revert MissingEntry();
        entry.frozen = true;
        emit AuditEntryFrozen(entryId);
    }

    function getEntry(bytes32 entryId) external view returns (AuditEntry memory) {
        if (entries[entryId].createdAt == 0) revert MissingEntry();
        return entries[entryId];
    }

    function entryExists(bytes32 entryId) external view returns (bool) {
        return entries[entryId].createdAt != 0;
    }
}
