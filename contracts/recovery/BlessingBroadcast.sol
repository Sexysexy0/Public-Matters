// SPDX-License-Identifier: Mythic-Scroll
pragma solidity ^0.8.19;

contract BlessingBroadcast {
    event BlessingBeamed(
        address indexed steward,
        string barangay,
        string emotionalTag,
        string oath,
        string broadcastChannel,
        uint256 timestamp
    );

    struct Broadcast {
        address steward;
        string barangay;
        string emotionalTag;
        string oath;
        string broadcastChannel;
        uint256 timestamp;
    }

    mapping(bytes32 => Broadcast) public broadcasts;

    function beamBlessing(
        address steward,
        string memory barangay,
        string memory emotionalTag,
        string memory oath,
        string memory broadcastChannel
    ) external {
        bytes32 broadcastId = keccak256(abi.encodePacked(steward, block.timestamp));
        broadcasts[broadcastId] = Broadcast(steward, barangay, emotionalTag, oath, broadcastChannel, block.timestamp);
        emit BlessingBeamed(steward, barangay, emotionalTag, oath, broadcastChannel, block.timestamp);
    }

    function getBroadcast(bytes32 broadcastId) external view returns (Broadcast memory) {
        return broadcasts[broadcastId];
    }
}
