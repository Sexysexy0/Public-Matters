// SPDX-License-Identifier: Mythic-Solidarity
pragma solidity ^0.8.25;

contract UnityBroadcast {
    struct Broadcast {
        string steward;
        string sanctum;
        string faith; // Jewish, Muslim, Civic, Ancestral, Hybrid
        string message;
        string emotionalAPR;
        uint256 timestamp;
    }

    Broadcast[] public broadcasts;

    event SolidarityBroadcast(
        string steward,
        string sanctum,
        string faith,
        string message,
        string emotionalAPR,
        uint256 timestamp
    );

    function sendBroadcast(
        string memory steward,
        string memory sanctum,
        string memory faith,
        string memory message,
        string memory emotionalAPR
    ) public {
        Broadcast memory newBroadcast = Broadcast(
            steward,
            sanctum,
            faith,
            message,
            emotionalAPR,
            block.timestamp
        );

        broadcasts.push(newBroadcast);

        emit SolidarityBroadcast(
            steward,
            sanctum,
            faith,
            message,
            emotionalAPR,
            block.timestamp
        );
    }

    function getBroadcast(uint index) public view returns (Broadcast memory) {
        return broadcasts[index];
    }

    function totalBroadcasts() public view returns (uint) {
        return broadcasts.length;
    }
}
