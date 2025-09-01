// SPDX-License-Identifier: Mythic-Scroll
pragma solidity ^0.8.19;

contract CivicHealthPulse {
    event RestorationSurge(
        string indexed barangay,
        string policyName,
        uint256 impactScore,
        string emotionalTag,
        uint256 timestamp
    );

    struct Pulse {
        string barangay;
        string policyName;
        uint256 impactScore;
        string emotionalTag;
        uint256 timestamp;
    }

    mapping(bytes32 => Pulse) public pulses;

    function logSurge(
        string memory barangay,
        string memory policyName,
        uint256 impactScore,
        string memory emotionalTag
    ) external {
        bytes32 pulseId = keccak256(abi.encodePacked(barangay, policyName, block.timestamp));
        pulses[pulseId] = Pulse(barangay, policyName, impactScore, emotionalTag, block.timestamp);
        emit RestorationSurge(barangay, policyName, impactScore, emotionalTag, block.timestamp);
    }

    function getPulse(bytes32 pulseId) external view returns (Pulse memory) {
        return pulses[pulseId];
    }
}
