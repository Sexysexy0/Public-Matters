// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title CivicAccountabilityRegistry
 * @notice Public, append-only registry for civic accountability records.
 *
 * Initial pilot use case: press-access incidents. The contract records
 * that a claim and evidence hash were filed at a particular time; it does
 * not adjudicate truth or replace legal due process.
 */
contract CivicAccountabilityRegistry {
    enum RecordType {
        PRESS_ACCESS_INCIDENT,
        CITIZEN_MANDATE,
        LEADERSHIP_RENEWAL,
        POLICY_NARRATIVE
    }

    enum RecordStatus {
        FILED,
        ACKNOWLEDGED,
        UNDER_REVIEW,
        RESOLVED,
        DISMISSED
    }

    struct Record {
        bytes32 id;
        RecordType recordType;
        RecordStatus status;
        bytes32 subjectHash;
        bytes32 evidenceHash;
        string title;
        string summary;
        address filer;
        uint256 filedAt;
        uint256 updatedAt;
        string response;
    }

    address public governor;
    address public auditor;

    mapping(bytes32 => Record) private records;
    bytes32[] private recordIds;

    event RecordFiled(
        bytes32 indexed id,
        RecordType recordType,
        bytes32 indexed subjectHash,
        bytes32 evidenceHash,
        address indexed filer
    );

    event RecordUpdated(bytes32 indexed id, RecordStatus status, string response);

    event AuditorChanged(address indexed previousAuditor, address indexed newAuditor);

    error Unauthorized();
    error ZeroAddress();
    error RecordAlreadyFiled();
    error RecordNotFound();
    error InvalidRecordType();

    modifier onlyGovernor() {
        if (msg.sender != governor) revert Unauthorized();
        _;
    }

    modifier onlyAuditor() {
        if (msg.sender != auditor && msg.sender != governor) {
            revert Unauthorized();
        }
        _;
    }

    modifier recordExists(bytes32 id) {
        if (records[id].filedAt == 0) revert RecordNotFound();
        _;
    }

    constructor(address initialAuditor) {
        if (initialAuditor == address(0)) revert ZeroAddress();
        governor = msg.sender;
        auditor = initialAuditor;
    }

    function setAuditor(address newAuditor) external onlyGovernor {
        if (newAuditor == address(0)) revert ZeroAddress();
        emit AuditorChanged(auditor, newAuditor);
        auditor = newAuditor;
    }

    function fileRecord(
        bytes32 id,
        RecordType recordType,
        bytes32 subjectHash,
        bytes32 evidenceHash,
        string calldata title,
        string calldata summary
    ) external returns (bool) {
        if (records[id].filedAt != 0) revert RecordAlreadyFiled();

        if (
            recordType != RecordType.PRESS_ACCESS_INCIDENT && recordType != RecordType.CITIZEN_MANDATE
                && recordType != RecordType.LEADERSHIP_RENEWAL && recordType != RecordType.POLICY_NARRATIVE
        ) {
            revert InvalidRecordType();
        }

        records[id] = Record({
            id: id,
            recordType: recordType,
            status: RecordStatus.FILED,
            subjectHash: subjectHash,
            evidenceHash: evidenceHash,
            title: title,
            summary: summary,
            filer: msg.sender,
            filedAt: block.timestamp,
            updatedAt: block.timestamp,
            response: ""
        });

        recordIds.push(id);

        emit RecordFiled(id, recordType, subjectHash, evidenceHash, msg.sender);

        return true;
    }

    function updateRecord(bytes32 id, RecordStatus newStatus, string calldata response)
        external
        onlyAuditor
        recordExists(id)
    {
        Record storage record = records[id];
        record.status = newStatus;
        record.updatedAt = block.timestamp;
        record.response = response;

        emit RecordUpdated(id, newStatus, response);
    }

    function getRecord(bytes32 id) external view recordExists(id) returns (Record memory) {
        return records[id];
    }

    function totalRecords() external view returns (uint256) {
        return recordIds.length;
    }

    function getAllRecordIds() external view returns (bytes32[] memory) {
        return recordIds;
    }
}
