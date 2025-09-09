// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

contract BitMarketScrollchainMixerDetectionProtocol {
    address public steward;
    mapping(string => bool) public flaggedMixers;
    mapping(string => string) public mixerType;

    event MixerFlagged(string mixer, string type, uint timestamp);

    function flagMixer(string memory mixer, string memory type) public {
        flaggedMixers[mixer] = true;
        mixerType[mixer] = type;
        emit MixerFlagged(mixer, type, block.timestamp);
    }

    function isFlagged(string memory mixer) public view returns (bool) {
        return flaggedMixers[mixer];
    }

    function getMixerType(string memory mixer) public view returns (string memory) {
        return mixerType[mixer];
    }
}
