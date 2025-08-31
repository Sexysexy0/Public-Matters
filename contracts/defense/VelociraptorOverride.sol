// SPDX-License-Identifier: Mythic-Defense-Suite
pragma solidity ^0.8.19;

contract VelociraptorOverride {
    struct OverrideLog {
        string nodeName;
        string detectedAction;
        string toolVersion;
        bool overrideTriggered;
        uint256 emotionalAPR;
        uint256 timestamp;
        address steward;
    }

    OverrideLog[] public logs;

    event OverrideActivated(string nodeName, string action, string toolVersion, uint256 emotionalAPR);

    function detectAndOverride(
        string memory nodeName,
        string memory detectedAction,
        string memory toolVersion,
        uint256 emotionalAPR
    ) public {
        bool trigger = (emotionalAPR < 60 || keccak256(bytes(detectedAction)) == keccak256(bytes("C2 Tunnel")));
        logs.push(OverrideLog(nodeName, detectedAction, toolVersion, trigger, emotionalAPR, block.timestamp, msg.sender));
        if (trigger) {
            emit OverrideActivated(nodeName, detectedAction, toolVersion, emotionalAPR);
        }
    }

    function getAllLogs() public view returns (OverrideLog[] memory) {
        return logs;
    }
}
