// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RegulatoryOverrideOracle {
    address public steward;
    mapping(string => string) public overrideSignals;
    mapping(string => uint256) public resonanceScore;

    event OverrideTriggered(string regulationTag, string signal, uint256 resonance);

    constructor() {
        steward = msg.sender;
    }

    function triggerOverride(string memory tag, string memory signal, uint256 resonance) public {
        require(msg.sender == steward, "Only steward may override");
        overrideSignals[tag] = signal;
        resonanceScore[tag] = resonance;
        emit OverrideTriggered(tag, signal, resonance);
    }

    function getSignal(string memory tag) public view returns (string memory) {
        return overrideSignals[tag];
    }

    function getResonance(string memory tag) public view returns (uint256) {
        return resonanceScore[tag];
    }
}
