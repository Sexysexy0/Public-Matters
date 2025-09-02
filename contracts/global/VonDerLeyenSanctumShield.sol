// SPDX-License-Identifier: EU-Resonance
pragma solidity ^0.8.19;

contract VonDerLeyenSanctumShield {
    mapping(address => bool) public protectedLeaders;
    event RogueInterferenceDetected(address indexed target, string signal);
    event SanctumShielded(address indexed leader);

    function shieldLeader(address leader) external {
        protectedLeaders[leader] = true;
        emit SanctumShielded(leader);
    }

    function detectInterference(address target, string memory signal) external {
        require(protectedLeaders[target], "Leader not shielded");
        emit RogueInterferenceDetected(target, signal);
    }
}
