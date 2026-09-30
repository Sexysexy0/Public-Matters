// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title TransparencyRegistry
 * @dev Immutable tracking of public petitions, institutional accountability, and governance audits.
 */
contract TransparencyRegistry {
    struct IncidentReport {
        string targetEntity;
        string category; // e.g., "Regulatory Disruption", "Conflict of Interest"
        string detailsUri;
        uint256 timestamp;
        address reporter;
        bool verified;
    }

    mapping(uint256 => IncidentReport) public reports;
    uint256 public reportCount;

    event IncidentLogged(uint256 indexed reportId, string targetEntity, string category, address reporter);

    function logIncident(string memory _targetEntity, string memory _category, string memory _detailsUri) public {
        reportCount++;
        reports[reportCount] = IncidentReport({
            targetEntity: _targetEntity,
            category: _category,
            detailsUri: _detailsUri,
            timestamp: block.timestamp,
            reporter: msg.sender,
            verified: false
        });

        emit IncidentLogged(reportCount, _targetEntity, _category, msg.sender);
    }
}
