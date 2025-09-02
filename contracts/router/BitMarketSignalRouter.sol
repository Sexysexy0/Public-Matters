// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BitMarketSignalRouter {
    address public steward;
    mapping(string => string) public vendorSignals;
    mapping(string => uint256) public resonanceScore;

    event SignalBroadcasted(string vendorTag, string signal, uint256 resonance);

    constructor() {
        steward = msg.sender;
    }

    function broadcastSignal(string memory tag, string memory signal, uint256 resonance) public {
        require(msg.sender == steward, "Only steward may broadcast");
        vendorSignals[tag] = signal;
        resonanceScore[tag] = resonance;
        emit SignalBroadcasted(tag, signal, resonance);
    }

    function getSignal(string memory tag) public view returns (string memory) {
        return vendorSignals[tag];
    }

    function getResonance(string memory tag) public view returns (uint256) {
        return resonanceScore[tag];
    }
}
