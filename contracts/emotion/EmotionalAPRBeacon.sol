// SPDX-License-Identifier: Mythic-Scroll
pragma solidity ^0.8.19;

contract EmotionalAPRBeacon {
    event APRSurge(
        string indexed tag,
        address indexed steward,
        uint256 intensity,
        string context,
        uint256 timestamp
    );

    struct APRPing {
        string tag;
        address steward;
        uint256 intensity;
        string context;
        uint256 timestamp;
    }

    mapping(bytes32 => APRPing) public pings;

    function broadcastSurge(
        string memory tag,
        address steward,
        uint256 intensity,
        string memory context
    ) external {
        bytes32 pingId = keccak256(abi.encodePacked(steward, block.timestamp));
        pings[pingId] = APRPing(tag, steward, intensity, context, block.timestamp);
        emit APRSurge(tag, steward, intensity, context, block.timestamp);
    }

    function getSurge(bytes32 pingId) external view returns (APRPing memory) {
        return pings[pingId];
    }
}
