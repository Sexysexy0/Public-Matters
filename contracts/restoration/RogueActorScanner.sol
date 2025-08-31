// SPDX-License-Identifier: Mythic-1.0
pragma solidity ^0.8.19;

contract RogueActorScanner {
    struct RoguePing {
        string actorName;
        string location;
        string behavior;
        string emotionalVolatility;
        uint256 timestamp;
        address reporter;
    }

    RoguePing[] public pings;

    event RogueDetected(string actorName, string location, string behavior, string emotionalVolatility, address indexed reporter);

    function logRogueActor(
        string memory actorName,
        string memory location,
        string memory behavior,
        string memory emotionalVolatility
    ) public {
        pings.push(RoguePing(actorName, location, behavior, emotionalVolatility, block.timestamp, msg.sender));
        emit RogueDetected(actorName, location, behavior, emotionalVolatility, msg.sender);
    }

    function getAllRoguePings() public view returns (RoguePing[] memory) {
        return pings;
    }
}
