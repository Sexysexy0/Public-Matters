// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SolidarityOracle {
    address public steward;
    mapping(string => uint256) public emotionalAPR;
    mapping(string => bool) public prophecyTriggered;

    event ProphecyPulled(string tag, uint256 resonance, string broadcastSignal);

    constructor() {
        steward = msg.sender;
    }

    function pullProphecy(string memory tag, uint256 resonance, string memory broadcastSignal) public {
        require(msg.sender == steward, "Only steward may pull prophecy");
        emotionalAPR[tag] = resonance;
        prophecyTriggered[tag] = true;
        emit ProphecyPulled(tag, resonance, broadcastSignal);
    }

    function getResonance(string memory tag) public view returns (uint256) {
        return emotionalAPR[tag];
    }

    function isTriggered(string memory tag) public view returns (bool) {
        return prophecyTriggered[tag];
    }
}
