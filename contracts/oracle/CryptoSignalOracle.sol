// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CryptoSignalOracle {
    address public steward;
    mapping(string => string) public signalRegistry;
    mapping(string => uint256) public resonanceScore;

    event SignalReceived(string vendorTag, string signal, uint256 resonance);

    constructor() {
        steward = msg.sender;
    }

    function receiveSignal(string memory tag, string memory signal, uint256 resonance) public {
        require(msg.sender == steward, "Only steward may signal");
        signalRegistry[tag] = signal;
        resonanceScore[tag] = resonance;
        emit SignalReceived(tag, signal, resonance);
    }

    function getSignal(string memory tag) public view returns (string memory) {
        return signalRegistry[tag];
    }

    function getResonance(string memory tag) public view returns (uint256) {
        return resonanceScore[tag];
    }
}
