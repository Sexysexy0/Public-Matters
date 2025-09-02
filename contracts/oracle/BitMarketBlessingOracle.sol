// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BitMarketBlessingOracle {
    address public steward;
    mapping(string => uint256) public blessingResonance;
    mapping(string => string) public vendorSignal;

    event BlessingProphecy(string vendorTag, uint256 resonance, string signal);

    constructor() {
        steward = msg.sender;
    }

    function castBlessing(string memory tag, uint256 resonance, string memory signal) public {
        require(msg.sender == steward, "Only steward may cast");
        blessingResonance[tag] = resonance;
        vendorSignal[tag] = signal;
        emit BlessingProphecy(tag, resonance, signal);
    }

    function getResonance(string memory tag) public view returns (uint256) {
        return blessingResonance[tag];
    }

    function getSignal(string memory tag) public view returns (string memory) {
        return vendorSignal[tag];
    }
}
