// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./OperatorPrivileges.sol";

contract AgentTelemetryRegistry {
    OperatorPrivileges public immutable privileges;

    struct TelemetryRecord {
        uint256 id;
        bytes32 agentHash;
        string  status;
        bytes32 metricsHash;
        uint256 timestamp;
        address recordedBy;
    }

    mapping(uint256 => TelemetryRecord) public records;
    mapping(bytes32 => uint256[]) public recordsByAgent;
    uint256 public totalRecords;

    event TelemetryRecorded(
        uint256 indexed id,
        bytes32 indexed agentHash,
        string status,
        bytes32 metricsHash,
        address recordedBy
    );

    modifier onlyOperator() {
        require(privileges.isOperator(msg.sender), "Not authorized operator");
        _;
    }

    constructor(address _privileges) {
        require(_privileges != address(0), "privileges=0");
        privileges = OperatorPrivileges(_privileges);
    }

    function recordTelemetry(
        bytes32 agentHash,
        string calldata status,
        bytes32 metricsHash
    ) external onlyOperator returns (uint256) {
        require(agentHash != bytes32(0), "agentHash=0");

        totalRecords++;
        uint256 id = totalRecords;

        records[id] = TelemetryRecord({
            id: id,
            agentHash: agentHash,
            status: status,
            metricsHash: metricsHash,
            timestamp: block.timestamp,
            recordedBy: msg.sender
        });

        recordsByAgent[agentHash].push(id);

        emit TelemetryRecorded(id, agentHash, status, metricsHash, msg.sender);
        return id;
    }

    function getAgentRecords(bytes32 agentHash) external view returns (uint256[] memory) {
        return recordsByAgent[agentHash];
    }
}
