// SPDX-License-Identifier: HumanitarianSanctum
pragma solidity ^0.8.19;

contract AidWorkerProtectionRouter {
    struct ProtectionSignal {
        address workerID;
        string missionZone; // e.g., "Gaza", "Sudan", "Haiti"
        string riskLevel;   // e.g., "High", "Critical", "Moderate"
        bool casualtyReported;
        bool verified;
        string stewardNote;
    }

    mapping(address => ProtectionSignal) public protectionRegistry;

    event ProtectionTagged(address workerID, string missionZone);
    event ProtectionVerified(address workerID);

    function tagProtection(address workerID, string memory missionZone, string memory riskLevel, bool casualtyReported, string memory stewardNote) public {
        protectionRegistry[workerID] = ProtectionSignal(workerID, missionZone, riskLevel, casualtyReported, false, stewardNote);
        emit ProtectionTagged(workerID, missionZone);
    }

    function verifyProtection(address workerID) public {
        require(bytes(protectionRegistry[workerID].missionZone).length > 0, "Worker not tagged");
        protectionRegistry[workerID].verified = true;
        emit ProtectionVerified(workerID);
    }

    function getProtectionStatus(address workerID) public view returns (ProtectionSignal memory) {
        return protectionRegistry[workerID];
    }
}
