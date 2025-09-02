// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ProphecyLoopOracle {
    address public steward;
    mapping(string => uint256) public resonanceScore;
    mapping(string => string) public prophecySignal;

    event ProphecyLoopTriggered(string tag, uint256 resonance, string signal);

    constructor() {
        steward = msg.sender;
    }

    function triggerLoop(string memory tag, uint256 resonance, string memory signal) public {
        require(msg.sender == steward, "Only steward may trigger");
        resonanceScore[tag] = resonance;
        prophecySignal[tag] = signal;
        emit ProphecyLoopTriggered(tag, resonance, signal);
    }

    function getSignal(string memory tag) public view returns (string memory) {
        return prophecySignal[tag];
    }

    function getResonance(string memory tag) public view returns (uint256) {
        return resonanceScore[tag];
    }
}
