// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.19;

contract BlessingBroadcastRelay {
    address public steward;

    struct Broadcast {
        string contractor;
        string projectName;
        string emotionalTag;
        string mediaNode;
        bool broadcasted;
        uint256 timestamp;
    }

    Broadcast[] public broadcasts;

    event BlessingBroadcasted(string contractor, string projectName, string mediaNode);

    constructor() {
        steward = msg.sender;
    }

    function broadcastBlessing(
        string memory contractor,
        string memory projectName,
        string memory emotionalTag,
        string memory mediaNode
    ) public {
        broadcasts.push(Broadcast(contractor, projectName, emotionalTag, mediaNode, true, block.timestamp));
        emit BlessingBroadcasted(contractor, projectName, mediaNode);
    }

    function getBroadcast(uint256 index) public view returns (Broadcast memory) {
        return broadcasts[index];
    }

    function totalBroadcasts() public view returns (uint256) {
        return broadcasts.length;
    }
}
