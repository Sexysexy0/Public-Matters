// SPDX-License-Identifier: Firewall-Telemetry-License  
pragma solidity ^0.8.19;

contract SanctumFirewallTelemetry {
    struct FirewallStatus {
        string sanctumName;
        uint firewallStrength; // 0–100 scale
        uint signalIntegrity;  // 0–100 scale
        bool emotionalAPRStable;
        uint timestamp;
    }

    FirewallStatus[] public telemetryLog;

    event TelemetryUpdated(string sanctumName, uint firewallStrength, uint signalIntegrity);

    function updateTelemetry(
        string memory sanctumName,
        uint firewallStrength,
        uint signalIntegrity,
        bool emotionalAPRStable
    ) public {
        telemetryLog.push(FirewallStatus(
            sanctumName,
            firewallStrength,
            signalIntegrity,
            emotionalAPRStable,
            block.timestamp
        ));
        emit TelemetryUpdated(sanctumName, firewallStrength, signalIntegrity);
    }

    function getTelemetry(uint index) public view returns (FirewallStatus memory) {
        require(index < telemetryLog.length, "Invalid index");
        return telemetryLog[index];
    }

    function totalTelemetryEntries() public view returns (uint) {
        return telemetryLog.length;
    }
}
