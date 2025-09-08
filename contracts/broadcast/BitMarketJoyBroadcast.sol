// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

contract BitMarketJoyBroadcast {
    address public steward;
    event JoyBroadcasted(string missionTitle, string rippleZone, uint aprScore, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function broadcastJoy(
        string memory missionTitle,
        string memory rippleZone,
        uint aprScore
    ) public {
        require(aprScore >= 0 && aprScore <= 100, "Invalid APR score");
        emit JoyBroadcasted(missionTitle, rippleZone, aprScore, block.timestamp);
    }
}
