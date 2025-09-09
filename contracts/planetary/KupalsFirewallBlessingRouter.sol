// SPDX-License-Identifier: Kinder-Queen-License
pragma solidity ^0.8.0;

contract KupalsFirewallBlessingRouter {
    address public steward;
    mapping(string => bool) public rogueSignals;

    event SignalBlocked(string signal, uint timestamp);
    event BlessingRouted(string signal, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function routeSignal(string memory signal) public {
        require(msg.sender == steward, "Only steward can route signals");
        if (rogueSignals[signal]) {
            emit SignalBlocked(signal, block.timestamp);
        } else {
            emit BlessingRouted(signal, block.timestamp);
        }
    }

    function flagRogueSignal(string memory signal) public {
        require(msg.sender == steward, "Only steward can flag signals");
        rogueSignals[signal] = true;
    }

    function isRogue(string memory signal) public view returns (bool) {
        return rogueSignals[signal];
    }
}
