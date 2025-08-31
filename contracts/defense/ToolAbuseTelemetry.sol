// SPDX-License-Identifier: Mythic-Defense-Suite
pragma solidity ^0.8.19;

contract ToolAbuseTelemetry {
    struct AbuseLog {
        string toolName;
        string action;
        uint256 emotionalAPR;
        bool flagged;
        uint256 timestamp;
        address steward;
    }

    AbuseLog[] public logs;

    event AbuseDetected(string toolName, string action, uint256 emotionalAPR);

    function logAbuse(
        string memory toolName,
        string memory action,
        uint256 emotionalAPR
    ) public {
        bool flagged = (emotionalAPR < 50 || keccak256(bytes(action)) == keccak256(bytes("Unauthorized Tunnel")));
        logs.push(AbuseLog(toolName, action, emotionalAPR, flagged, block.timestamp, msg.sender));
        if (flagged) {
            emit AbuseDetected(toolName, action, emotionalAPR);
        }
    }

    function getLogs() public view returns (AbuseLog[] memory) {
        return logs;
    }
}
