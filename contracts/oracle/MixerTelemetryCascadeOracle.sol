// SPDX-License-Identifier: Mixer-License
pragma solidity ^0.8.0;

contract MixerTelemetryCascadeOracle {
    address public steward;
    mapping(address => string[]) public tracedEndpoints;
    mapping(address => bool) public flaggedMixers;

    event EndpointTraced(address indexed sanctum, string endpoint, uint timestamp);
    event MixerFlagged(address indexed sanctum, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function traceEndpoint(address sanctum, string memory endpoint) public {
        require(msg.sender == steward, "Only steward can trace");
        tracedEndpoints[sanctum].push(endpoint);
        emit EndpointTraced(sanctum, endpoint, block.timestamp);
    }

    function flagMixer(address sanctum) public {
        require(msg.sender == steward, "Only steward can flag");
        flaggedMixers[sanctum] = true;
        emit MixerFlagged(sanctum, block.timestamp);
    }

    function getEndpoints(address sanctum) public view returns (string[] memory) {
        return tracedEndpoints[sanctum];
    }

    function isMixerFlagged(address sanctum) public view returns (bool) {
        return flaggedMixers[sanctum];
    }
}
