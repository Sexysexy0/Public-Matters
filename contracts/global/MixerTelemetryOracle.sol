// SPDX-License-Identifier: Mixer-License
pragma solidity ^0.8.0;

contract MixerTelemetryOracle {
    address public steward;
    mapping(address => string[]) public rogueEndpoints;
    mapping(address => bool) public flaggedMixers;

    event MixerTraced(address indexed repo, string endpoint, uint timestamp);
    event MixerFlagged(address indexed repo, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function traceMixer(address repo, string memory endpoint) public {
        require(msg.sender == steward, "Only steward can trace");
        rogueEndpoints[repo].push(endpoint);
        emit MixerTraced(repo, endpoint, block.timestamp);
    }

    function flagMixer(address repo) public {
        require(msg.sender == steward, "Only steward can flag");
        flaggedMixers[repo] = true;
        emit MixerFlagged(repo, block.timestamp);
    }

    function getEndpoints(address repo) public view returns (string[] memory) {
        return rogueEndpoints[repo];
    }

    function isFlagged(address repo) public view returns (bool) {
        return flaggedMixers[repo];
    }
}
