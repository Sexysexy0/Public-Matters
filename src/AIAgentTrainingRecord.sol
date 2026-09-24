// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./OperatorPrivileges.sol";

/**
 * @title AIAgentTrainingRecord
 * @notice Immutable proof of training + deployment authorization.
 *         Who trained, which model hash, who authorized, when.
 */
contract AIAgentTrainingRecord {
    OperatorPrivileges public privileges;

    struct TrainingRecord {
        bytes32 agentId;
        bytes32 modelHash;
        string metadataURI;
        address recordedBy;
        uint256 recordedAt;
        address authorizedBy;
        uint256 authorizedAt;
        bool active;
        bytes32 revocationReason;
    }

    mapping(bytes32 => TrainingRecord[]) internal _records;
    mapping(bytes32 => uint256) public activeRecordIndex;
    mapping(bytes32 => bool) public hasActiveAuthorization;

    event TrainingRecorded(bytes32 indexed agentId, uint256 recordIndex, bytes32 modelHash, string metadataURI);
    event DeploymentAuthorized(bytes32 indexed agentId, uint256 recordIndex, address approver);
    event AuthorizationRevoked(bytes32 indexed agentId, uint256 recordIndex, bytes32 reason, address revoker);

    modifier onlyOperator() {
        require(privileges.isOperator(msg.sender), "Not authorized operator");
        _;
    }

    constructor(address _privileges) {
        require(_privileges != address(0), "Invalid privileges");
        privileges = OperatorPrivileges(_privileges);
    }

    function recordTraining(bytes32 agentId, bytes32 modelHash, string calldata metadataURI)
        external
        onlyOperator
        returns (uint256)
    {
        require(modelHash != bytes32(0), "Invalid model hash");

        _records[agentId].push(
            TrainingRecord({
                agentId: agentId,
                modelHash: modelHash,
                metadataURI: metadataURI,
                recordedBy: msg.sender,
                recordedAt: block.timestamp,
                authorizedBy: address(0),
                authorizedAt: 0,
                active: false,
                revocationReason: bytes32(0)
            })
        );

        uint256 idx = _records[agentId].length - 1;
        emit TrainingRecorded(agentId, idx, modelHash, metadataURI);
        return idx;
    }

    function authorizeDeployment(bytes32 agentId, uint256 recordIndex) external onlyOperator {
        require(recordIndex < _records[agentId].length, "Record not found");

        TrainingRecord storage r = _records[agentId][recordIndex];
        require(r.authorizedBy == address(0), "Already authorized");

        r.authorizedBy = msg.sender;
        r.authorizedAt = block.timestamp;
        r.active = true;

        activeRecordIndex[agentId] = recordIndex;
        hasActiveAuthorization[agentId] = true;

        emit DeploymentAuthorized(agentId, recordIndex, msg.sender);
    }

    function revokeAuthorization(bytes32 agentId, bytes32 reason) external onlyOperator {
        require(hasActiveAuthorization[agentId], "No active authorization");

        uint256 idx = activeRecordIndex[agentId];
        TrainingRecord storage r = _records[agentId][idx];
        r.active = false;
        r.revocationReason = reason;

        hasActiveAuthorization[agentId] = false;

        emit AuthorizationRevoked(agentId, idx, reason, msg.sender);
    }

    function getRecordCount(bytes32 agentId) external view returns (uint256) {
        return _records[agentId].length;
    }

    function getRecord(bytes32 agentId, uint256 index) external view returns (TrainingRecord memory) {
        return _records[agentId][index];
    }

    function getActiveRecord(bytes32 agentId) external view returns (TrainingRecord memory) {
        require(hasActiveAuthorization[agentId], "No active authorization");
        return _records[agentId][activeRecordIndex[agentId]];
    }
}
