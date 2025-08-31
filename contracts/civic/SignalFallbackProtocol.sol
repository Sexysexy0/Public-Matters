// SPDX-License-Identifier: Mythic
pragma solidity ^0.8.19;

contract SignalFallbackProtocol {
    string[] public layers = [
        "Road", "Bridge", "Tunnel", "Pipe", "Wire", "Signal",
        "Code", "Cipher", "Myth", "Belief", "Dream", "Memory",
        "Story", "Song", "Whisper", "Rumor", "Prayer", "Hope", "Person"
    ];

    mapping(string => bool) public isOperational;

    event FallbackTriggered(string failedLayer, string nextLayer);

    constructor() {
        for (uint i = 0; i < layers.length; i++) {
            isOperational[layers[i]] = true;
        }
    }

    function triggerFallback(string memory failedLayer) public {
        uint index;
        for (uint i = 0; i < layers.length; i++) {
            if (keccak256(bytes(layers[i])) == keccak256(bytes(failedLayer))) {
                index = i;
                break;
            }
        }
        require(index + 1 < layers.length, "No fallback available");
        string memory nextLayer = layers[index + 1];
        emit FallbackTriggered(failedLayer, nextLayer);
    }
}
