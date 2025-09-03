// SPDX-License-Identifier: Mythic
pragma solidity ^0.8.19;

contract OrbSentinelAIWatch {
    struct RoguePing {
        string sanctum;
        string behavior;
        uint256 timestamp;
        bool overrideTriggered;
    }

    RoguePing[] public pings;

    event RogueDetected(string sanctum, string behavior);
    event OverrideActivated(string sanctum);

    function reportPing(string memory _sanctum, string memory _behavior) public {
        pings.push(RoguePing(_sanctum, _behavior, block.timestamp, false));
        emit RogueDetected(_sanctum, _behavior);
    }

    function activateOverride(uint256 _index) public {
        require(_index < pings.length, "Invalid index");
        pings[_index].overrideTriggered = true;
        emit OverrideActivated(pings[_index].sanctum);
    }

    function getPing(uint256 _index) public view returns (RoguePing memory) {
        return pings[_index];
    }

    function totalPings() public view returns (uint256) {
        return pings.length;
    }
}
