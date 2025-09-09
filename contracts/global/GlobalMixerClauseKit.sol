// SPDX-License-Identifier: Treaty-License
pragma solidity ^0.8.0;

contract GlobalMixerClauseKit {
    address public steward;
    mapping(string => bool) public flaggedEndpoints;
    mapping(address => bool) public nullifiedMixers;

    event EndpointFlagged(string endpoint, uint timestamp);
    event MixerNullified(address indexed mixer, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function flagEndpoint(string memory endpoint) public {
        require(msg.sender == steward, "Only steward can flag");
        flaggedEndpoints[endpoint] = true;
        emit EndpointFlagged(endpoint, block.timestamp);
    }

    function nullifyMixer(address mixer) public {
        require(msg.sender == steward, "Only steward can nullify");
        nullifiedMixers[mixer] = true;
        emit MixerNullified(mixer, block.timestamp);
    }

    function isEndpointFlagged(string memory endpoint) public view returns (bool) {
        return flaggedEndpoints[endpoint];
    }

    function isMixerNullified(address mixer) public view returns (bool) {
        return nullifiedMixers[mixer];
    }
}
