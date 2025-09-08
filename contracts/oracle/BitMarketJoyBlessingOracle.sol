// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

contract BitMarketJoyBlessingOracle {
    address public steward;
    uint public blessingThreshold = 90;

    event JoyBlessed(string missionTitle, string rippleZone, uint aprScore, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function evaluateJoy(
        string memory missionTitle,
        string memory rippleZone,
        uint aprScore
    ) public returns (bool) {
        bool blessed = aprScore >= blessingThreshold;
        if (blessed) {
            emit JoyBlessed(missionTitle, rippleZone, aprScore, block.timestamp);
        }
        return blessed;
    }

    function updateThreshold(uint newThreshold) public {
        require(msg.sender == steward, "Only steward may update threshold");
        blessingThreshold = newThreshold;
    }
}
