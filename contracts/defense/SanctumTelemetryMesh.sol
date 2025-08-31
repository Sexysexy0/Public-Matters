// SPDX-License-Identifier: Mythic-Mesh-Suite
pragma solidity ^0.8.19;

interface EmotionalFailsafeOracle {
    function getAPR(address steward) external view returns (uint256);
}

interface ToolAbuseTelemetry {
    function getLogs() external view returns (ToolAbuseTelemetry.AbuseLog[] memory);
}

interface VelociraptorOverride {
    function getAllLogs() external view returns (VelociraptorOverride.OverrideLog[] memory);
}

contract SanctumTelemetryMesh {
    EmotionalFailsafeOracle public aprOracle;
    ToolAbuseTelemetry public abuseTelemetry;
    VelociraptorOverride public overrideLog;

    constructor(
        address _aprOracle,
        address _abuseTelemetry,
        address _overrideLog
    ) {
        aprOracle = EmotionalFailsafeOracle(_aprOracle);
        abuseTelemetry = ToolAbuseTelemetry(_abuseTelemetry);
        overrideLog = VelociraptorOverride(_overrideLog);
    }

    struct MeshSnapshot {
        uint256 emotionalAPR;
        bool failsafeTriggered;
        uint256 overrideCount;
        uint256 abuseCount;
    }

    function getMeshSnapshot(address steward) public view returns (MeshSnapshot memory) {
        uint256 apr = aprOracle.getAPR(steward);
        bool failsafe = apr < 45;

        uint256 overrideCount = overrideLog.getAllLogs().length;
        uint256 abuseCount = abuseTelemetry.getLogs().length;

        return MeshSnapshot(apr, failsafe, overrideCount, abuseCount);
    }
}
