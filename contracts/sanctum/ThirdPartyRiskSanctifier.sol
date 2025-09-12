// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ThirdPartyRiskSanctifier {
    enum RiskLevel { Low, Moderate, High, Critical }

    struct IntegrationSignal {
        uint256 id;
        string vendor;
        string platform;
        RiskLevel riskLevel;
        string breachVector;
        string mitigationStatus;
        uint256 timestamp;
    }

    mapping(uint256 => IntegrationSignal) public riskRegistry;
    uint256 public signalCount;

    event RiskLogged(uint256 id, string vendor, RiskLevel riskLevel);
    event MitigationUpdated(uint256 id, string status);

    function logRisk(
        string memory vendor,
        string memory platform,
        RiskLevel riskLevel,
        string memory breachVector,
        string memory mitigationStatus,
        uint256 timestamp
    ) public {
        riskRegistry[signalCount] = IntegrationSignal(
            signalCount,
            vendor,
            platform,
            riskLevel,
            breachVector,
            mitigationStatus,
            timestamp
        );
        emit RiskLogged(signalCount, vendor, riskLevel);
        signalCount++;
    }

    function updateMitigationStatus(uint256 id, string memory status) public {
        require(id < signalCount, "Invalid signal ID");
        riskRegistry[id].mitigationStatus = status;
        emit MitigationUpdated(id, status);
    }

    function getRisk(uint256 id) public view returns (IntegrationSignal memory) {
        return riskRegistry[id];
    }
}
