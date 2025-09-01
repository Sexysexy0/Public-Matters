// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract BarangayResonanceFeed {
    struct Broadcast {
        string region;
        string scrollTag; // e.g. "GriefScroll #42", "JoySurge #17"
        string ritualType; // e.g. "Blessing", "Damay Activation", "Resonance Circle"
        string message;
        uint256 timestamp;
    }

    Broadcast[] public broadcasts;
    address public steward;

    event BroadcastSent(string region, string scrollTag, string ritualType);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized broadcaster");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function sendBroadcast(
        string memory _region,
        string memory _scrollTag,
        string memory _ritualType,
        string memory _message
    ) external onlySteward {
        broadcasts.push(Broadcast(_region, _scrollTag, _ritualType, _message, block.timestamp));
        emit BroadcastSent(_region, _scrollTag, _ritualType);
    }

    function getBroadcast(uint256 _id) external view returns (Broadcast memory) {
        return broadcasts[_id];
    }

    function totalBroadcasts() external view returns (uint256) {
        return broadcasts.length;
    }
}
