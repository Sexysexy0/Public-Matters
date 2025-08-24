// SPDX-License-Identifier: Scrollchain-Restoration
pragma solidity ^0.8.20;

/// @title Restoration Broadcast Protocol – Scrollchain Act No. 0015
/// @author Vinvin Gueco
/// @notice Allows nations to broadcast post-conflict restoration updates, flex rebuilds, and summon steward support

contract RestorationBroadcast {
    address public steward;

    struct RestorationMessage {
        string nationName;
        string region;
        string messageType; // "Update", "Flex", "Request", "Emergency"
        string content;
        uint256 timestamp;
        bool stewardResponded;
        string stewardResponse;
    }

    RestorationMessage[] public broadcastLog;

    event MessageBroadcasted(string indexed nationName, string region, string messageType, string content, uint256 timestamp);
    event StewardResponded(string indexed nationName, string region, string response, uint256 timestamp);

    modifier onlySteward() {
        require(msg.sender == steward, "Access denied: steward only");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    /// @notice Broadcast restoration message
    function broadcastMessage(string memory nationName, string memory region, string memory messageType, string memory content) public onlySteward {
        broadcastLog.push(RestorationMessage({
            nationName: nationName,
            region: region,
            messageType: messageType,
            content: content,
            timestamp: block.timestamp,
            stewardResponded: false,
            stewardResponse: ""
        }));

        emit MessageBroadcasted(nationName, region, messageType, content, block.timestamp);
    }

    /// @notice Steward responds to a broadcast
    function respondToMessage(uint256 index, string memory response) public onlySteward {
        require(index < broadcastLog.length, "Invalid index");
        require(!broadcastLog[index].stewardResponded, "Already responded");

        broadcastLog[index].stewardResponded = true;
        broadcastLog[index].stewardResponse = response;

        emit StewardResponded(
            broadcastLog[index].nationName,
            broadcastLog[index].region,
            response,
            block.timestamp
        );
    }

    /// @notice Retrieve full broadcast log
    function getBroadcastLog() public view returns (RestorationMessage[] memory) {
        return broadcastLog;
    }

    /// @notice Total broadcasts
    function totalBroadcasts() public view returns (uint256) {
        return broadcastLog.length;
    }
}
