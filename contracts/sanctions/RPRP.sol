// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract RPRP {
    event ExploitDetected(address indexed attacker, string payload);
    event ReversalTriggered(address indexed attacker, string reversedPayload);

    mapping(address => bool) public rogueList;

    function detectExploit(string memory payload) public {
        address attacker = tx.origin;
        rogueList[attacker] = true;
        emit ExploitDetected(attacker, payload);
        reverseExploit(attacker, payload);
    }

    function reverseExploit(address attacker, string memory payload) internal {
        string memory reversed = string(abi.encodePacked("REVERSED:", payload));
        emit ReversalTriggered(attacker, reversed);
        // Optional: auto-broadcast to BitMarketRogueRegistry
    }

    function isRogue(address sanctum) public view returns (bool) {
        return rogueList[sanctum];
    }
}
