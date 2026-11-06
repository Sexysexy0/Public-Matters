// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./OperatorPrivileges.sol";

contract SecurityIncidentResponseRegistryV2 {
    OperatorPrivileges public immutable privileges;

    enum IncidentStatus { REPORTED, INVESTIGATING, CONTAINED, RESOLVED }

    struct Incident {
        bytes32 id;
        bytes32 networkHash;
        bytes32 severityHash;
        IncidentStatus status;
        uint256 reportedAt;
        uint256 resolvedAt;
        bytes32 remediationHash;
    }

    mapping(bytes32 => Incident) public incidents;

    event IncidentReported(bytes32 indexed id, bytes32 indexed networkHash, bytes32 severityHash);
    event StatusUpdated(bytes32 indexed id, IncidentStatus newStatus);
    event RemediationLogged(bytes32 indexed id, bytes32 remediationHash);

    modifier onlyOperator() {
        require(privileges.isOperator(msg.sender), "Not authorized operator");
        _;
    }

    constructor(address _privileges) {
        require(_privileges != address(0), "privileges=0");
        privileges = OperatorPrivileges(_privileges);
    }

    function reportIncident(bytes32 id, bytes32 networkHash, bytes32 severityHash) external onlyOperator {
        require(incidents[id].reportedAt == 0, "Incident already exists");
        incidents[id] = Incident({
            id: id,
            networkHash: networkHash,
            severityHash: severityHash,
            status: IncidentStatus.REPORTED,
            reportedAt: block.timestamp,
            resolvedAt: 0,
            remediationHash: bytes32(0)
        });
        emit IncidentReported(id, networkHash, severityHash);
    }

    function updateStatus(bytes32 id, IncidentStatus newStatus) external onlyOperator {
        Incident storage inc = incidents[id];
        require(inc.reportedAt != 0, "Incident not found");
        require(inc.status != IncidentStatus.RESOLVED, "Incident already resolved");
        
        inc.status = newStatus;
        if (newStatus == IncidentStatus.RESOLVED) {
            inc.resolvedAt = block.timestamp;
        }
        emit StatusUpdated(id, newStatus);
    }

    function logRemediation(bytes32 id, bytes32 remediationHash) external onlyOperator {
        Incident storage inc = incidents[id];
        require(inc.reportedAt != 0, "Incident not found");
        inc.remediationHash = remediationHash;
        emit RemediationLogged(id, remediationHash);
    }
}
