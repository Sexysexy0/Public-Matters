// SPDX-License-Identifier: Mythic-Scroll
pragma solidity ^0.8.19;

contract GridPulseTracker {
    event EnergySurgeLogged(
        string indexed gridName,
        uint256 capacityMW,
        string emotionalTag,
        string sourceType,
        uint256 timestamp
    );

    struct Pulse {
        string gridName;
        uint256 capacityMW;
        string emotionalTag;
        string sourceType;
        uint256 timestamp;
    }

    mapping(bytes32 => Pulse) public pulses;

    function logSurge(
        string memory gridName,
        uint256 capacityMW,
        string memory emotionalTag,
        string memory sourceType
    ) external {
        bytes32 pulseId = keccak256(abi.encodePacked(gridName, block.timestamp));
        pulses[pulseId] = Pulse(gridName, capacityMW, emotionalTag, sourceType, block.timestamp);
        emit EnergySurgeLogged(gridName, capacityMW, emotionalTag, sourceType, block.timestamp);
    }

    function getPulse(bytes32 pulseId) external view returns (Pulse memory) {
        return pulses[pulseId];
    }
}
