// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DataValidationAndReporting {
    enum Role {
        Admin,
        Auditor,
        FieldOperator
    }
    enum StakeholderType {
        Funder,
        Executive,
        Community
    }

    struct Participant {
        bytes32 participantId;
        uint256 intakeTimestamp;
        bool isActive;
        string encryptedMetadataURI;
    }

    struct OutcomeMetric {
        uint256 categoryId;
        uint256 value;
        uint256 timestamp;
        bytes32 proofHash;
    }

    address public owner;
    mapping(address => Role) public userRoles;
    mapping(bytes32 => Participant) private participants;
    mapping(bytes32 => OutcomeMetric[]) private participantMetrics;

    event ParticipantRegistered(bytes32 indexed participantId, uint256 timestamp);
    event MetricRecorded(bytes32 indexed participantId, uint256 indexed categoryId, uint256 value);
    event AuditReportGenerated(StakeholderType indexed viewType, uint256 timestamp);

    modifier onlyRole(Role requiredRole) {
        require(userRoles[msg.sender] == requiredRole || msg.sender == owner, "Unauthorized: Insufficient role");
        _;
    }

    constructor() {
        owner = msg.sender;
        userRoles[msg.sender] = Role.Admin;
    }

    function assignRole(address account, Role role) external onlyRole(Role.Admin) {
        userRoles[account] = role;
    }

    function registerParticipant(bytes32 _rawInput, string calldata _encryptedMetadataURI)
        external
        onlyRole(Role.FieldOperator)
        returns (bytes32)
    {
        bytes32 pId = keccak256(abi.encodePacked(_rawInput, block.timestamp, msg.sender));
        require(!participants[pId].isActive, "Participant already exists");

        participants[pId] = Participant({
            participantId: pId,
            intakeTimestamp: block.timestamp,
            isActive: true,
            encryptedMetadataURI: _encryptedMetadataURI
        });

        emit ParticipantRegistered(pId, block.timestamp);
        return pId;
    }

    function recordMetric(bytes32 _participantId, uint256 _categoryId, uint256 _value, bytes32 _proofHash)
        external
        onlyRole(Role.FieldOperator)
    {
        require(participants[_participantId].isActive, "Participant not found");

        participantMetrics[_participantId].push(
            OutcomeMetric({categoryId: _categoryId, value: _value, timestamp: block.timestamp, proofHash: _proofHash})
        );

        emit MetricRecorded(_participantId, _categoryId, _value);
    }

    function getParticipantMetrics(bytes32 _participantId) external view returns (OutcomeMetric[] memory) {
        return participantMetrics[_participantId];
    }

    function triggerReportView(StakeholderType _viewType) external onlyRole(Role.Auditor) {
        emit AuditReportGenerated(_viewType, block.timestamp);
    }
}
