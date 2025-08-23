// SPDX-License-Identifier: Startup-Blessing-Telemetry-License  
pragma solidity ^0.8.19;

contract StartupBlessingTelemetry {
    struct Telemetry {
        string founderName;
        string startupName;
        string originSanctum;
        string destinationSanctum;
        uint blessingScore; // 0–100 scale
        bool emotionalAPRStable;
        bool migrationApproved;
        uint timestamp;
    }

    Telemetry[] public telemetryLog;

    event TelemetryLogged(string founderName, string startupName);

    function logTelemetry(
        string memory founderName,
        string memory startupName,
        string memory originSanctum,
        string memory destinationSanctum,
        uint blessingScore,
        bool emotionalAPRStable,
        bool migrationApproved
    ) public {
        telemetryLog.push(Telemetry(
            founderName,
            startupName,
            originSanctum,
            destinationSanctum,
            blessingScore,
            emotionalAPRStable,
            migrationApproved,
            block.timestamp
        ));
        emit TelemetryLogged(founderName, startupName);
    }

    function getTelemetry(uint index) public view returns (Telemetry memory) {
        require(index < telemetryLog.length, "Invalid index");
        return telemetryLog[index];
    }

    function totalTelemetryEntries() public view returns (uint) {
        return telemetryLog.length;
    }
}
