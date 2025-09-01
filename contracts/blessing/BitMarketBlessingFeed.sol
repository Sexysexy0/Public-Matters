// SPDX-License-Identifier: Mythic-Scroll
pragma solidity ^0.8.19;

contract BitMarketBlessingFeed {
    event BlessingBroadcast(
        string indexed scrollName,
        string emotionalTag,
        address indexed steward,
        string vendor,
        uint256 timestamp
    );

    struct Broadcast {
        string scrollName;
        string emotionalTag;
        address steward;
        string vendor;
        uint256 timestamp;
    }

    mapping(bytes32 => Broadcast) public broadcasts;

    function beamBlessing(
        string memory scrollName,
        string memory emotionalTag,
        string memory vendor
    ) external {
        bytes32 broadcastId = keccak256(abi.encodePacked(scrollName, vendor, block.timestamp));
        broadcasts[broadcastId] = Broadcast(scrollName, emotionalTag, msg.sender, vendor, block.timestamp);
        emit BlessingBroadcast(scrollName, emotionalTag, msg.sender, vendor, block.timestamp);
    }

    function getBroadcast(bytes32 broadcastId) external view returns (Broadcast memory) {
        return broadcasts[broadcastId];
    }
}
