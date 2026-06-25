// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title PatientIntegrityLedger
 * @notice Provides an immutable verification layer for patient diagnostic logs, completely eliminating historical medical record falsification or tampering.
 */
contract PatientIntegrityLedger {
    event DiagnosticLogged(bytes32 indexed recordId, address indexed patient, bytes32 encryptedDataHash);
    event RecordVerifiedTrue(bytes32 indexed recordId, address indexed auditorNode);

    address public registrySteward;
    uint256 public totalVerifiedRecords;

    struct MedicalRecord {
        address patientAddress;
        uint256 logBlock;
        bytes32 dataHash; // Keccak-256 fingerprint ng diagnostic file (e.g., IPFS link)
        bool exists;
    }

    mapping(bytes32 => MedicalRecord) public masterRecordRegistry;
    mapping(address => bool) public authorizedMedicalNodes; // Lehitimong mga laboratoryo at independent doctors

    constructor() {
        registrySteward = msg.sender;
        authorizedMedicalNodes[msg.sender] = true;
    }

    modifier onlySteward() {
        require(msg.sender == registrySteward, "Access Denied: Steward signature failure");
        _;
    }

    modifier onlyAuthorizedNode() {
        require(authorizedMedicalNodes[msg.sender], "Access Denied: Caller is not an authorized medical node");
        _;
    }

    function configureMedicalNode(address _node, bool _status) external onlySteward {
        authorizedMedicalNodes[_node] = _status;
    }

    /**
     * @notice Immutably logs a patient's diagnostic results. This can never be deleted, altered, or replaced by any entity.
     */
    function logPatientDiagnostic(bytes32 _recordId, address _patient, bytes32 _dataHash) external onlyAuthorizedNode {
        require(!masterRecordRegistry[_recordId].exists, "Collision Intercept: Record already sealed");
        
        masterRecordRegistry[_recordId] = MedicalRecord({
            patientAddress: _patient,
            logBlock: block.number,
            dataHash: _dataHash,
            exists: true
        });

        totalVerifiedRecords += 1;
        emit DiagnosticLogged(_recordId, _patient, _dataHash);
    }
}

