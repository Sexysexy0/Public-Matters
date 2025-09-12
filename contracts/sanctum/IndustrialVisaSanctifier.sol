// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract IndustrialVisaSanctifier {
    enum VisaStatus { Pending, Approved, Rejected }
    enum WorkerType { Technician, Engineer, Operator, Specialist }

    struct VisaRecord {
        uint256 id;
        string workerName;
        WorkerType workerType;
        string hostCountry;
        VisaStatus status;
        string clauseReference;
        uint256 timestamp;
    }

    mapping(uint256 => VisaRecord) public visaRegistry;
    uint256 public visaCount;

    event VisaLogged(uint256 id, string workerName, VisaStatus status);
    event StatusUpdated(uint256 id, VisaStatus newStatus);

    function logVisa(
        string memory workerName,
        WorkerType workerType,
        string memory hostCountry,
        VisaStatus status,
        string memory clauseReference,
        uint256 timestamp
    ) public {
        visaRegistry[visaCount] = VisaRecord(
            visaCount,
            workerName,
            workerType,
            hostCountry,
            status,
            clauseReference,
            timestamp
        );
        emit VisaLogged(visaCount, workerName, status);
        visaCount++;
    }

    function updateVisaStatus(uint256 id, VisaStatus newStatus) public {
        require(id < visaCount, "Invalid visa ID");
        visaRegistry[id].status = newStatus;
        emit StatusUpdated(id, newStatus);
    }

    function getVisa(uint256 id) public view returns (VisaRecord memory) {
        return visaRegistry[id];
    }
}
