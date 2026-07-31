// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title SovereignEHRVault
 * @notice Codifies Issues #63, #64, #65, #66, #78.
 *         Provides encrypted IPFS pointers, strict RBAC, and gas-optimized access audit logs.
 */
contract SovereignEHRVault {
    
    enum Role { NONE, PATIENT, DOCTOR, AUDITOR }

    struct EncryptedRecord {
        bytes32 ipfsHashCID;      // Encrypted IPFS CID hash
        bytes32 symmetricKeyHash;  // Hash of the ephemeral encryption key
        uint256 timestamp;
        address registeredBy;
    }

    struct PatientProfile {
        bool isRegistered;
        uint256 recordCount;
    }

    // Role Access Mapping
    mapping(address => Role) public roles;
    // Patient address => Record ID => Encrypted Record
    mapping(address => mapping(uint256 => EncryptedRecord)) private patientRecords;
    mapping(address => PatientProfile) public patients;

    // Events (Audit Trail - Issue #65)
    event RoleAssigned(address indexed account, Role role);
    event RecordAdded(address indexed patient, uint256 indexed recordId, bytes32 ipfsHashCID);
    event RecordAccessed(address indexed patient, address indexed accessor, uint256 indexed recordId, uint256 timestamp);

    modifier onlyRole(Role requiredRole) {
        require(roles[msg.sender] == requiredRole, "EHRVault: Unauthorized role");
        _;
    }

    constructor() {
        roles[msg.sender] = Role.AUDITOR;
    }

    function registerRole(address account, Role role) external onlyRole(Role.AUDITOR) {
        roles[account] = role;
        emit RoleAssigned(account, role);
    }

    function registerPatient(address patientAddress) external {
        require(!patients[patientAddress].isRegistered, "EHRVault: Already registered");
        patients[patientAddress].isRegistered = true;
        roles[patientAddress] = Role.PATIENT;
        emit RoleAssigned(patientAddress, Role.PATIENT);
    }

    /**
     * @notice Add Encrypted IPFS Record (Issue #63, #78)
     */
    function addRecord(
        address patient,
        bytes32 ipfsHashCID,
        bytes32 symmetricKeyHash
    ) external {
        require(
            msg.sender == patient || roles[msg.sender] == Role.DOCTOR,
            "EHRVault: Only patient or authorized doctor can add records"
        );
        require(patients[patient].isRegistered, "EHRVault: Patient not registered");

        uint256 currentId = patients[patient].recordCount;
        patientRecords[patient][currentId] = EncryptedRecord({
            ipfsHashCID: ipfsHashCID,
            symmetricKeyHash: symmetricKeyHash,
            timestamp: block.timestamp,
            registeredBy: msg.sender
        });

        patients[patient].recordCount++;
        emit RecordAdded(patient, currentId, ipfsHashCID);
    }

    /**
     * @notice Fetch record with automated audit log emission (Issue #65)
     */
    function getRecord(address patient, uint256 recordId) external returns (bytes32 ipfsHashCID, bytes32 symmetricKeyHash, uint256 timestamp) {
        require(recordId < patients[patient].recordCount, "EHRVault: Invalid record ID");
        require(
            msg.sender == patient || roles[msg.sender] == Role.DOCTOR || roles[msg.sender] == Role.AUDITOR,
            "EHRVault: Access denied"
        );

        EncryptedRecord memory rec = patientRecords[patient][recordId];
        emit RecordAccessed(patient, msg.sender, recordId, block.timestamp);
        
        return (rec.ipfsHashCID, rec.symmetricKeyHash, rec.timestamp);
    }
}
