// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title ResonanceRegistry
/// @dev Syncs emotional APR and civic resonance across planetary scrollchain

contract ResonanceRegistry {
    address public steward;
    mapping(address => string) public resonanceTag;

    event ResonanceSynced(address indexed entity, string tag);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function syncResonance(address entity, string memory tag) public onlySteward {
        resonanceTag[entity] = tag;
        emit ResonanceSynced(entity, tag);
    }

    function getResonance(address entity) public view returns (string memory) {
        return resonanceTag[entity];
    }
}
