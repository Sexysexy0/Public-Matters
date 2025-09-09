// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

contract BitMarketScrollchainMixerTelemetryProtocol {
    address public steward;
    mapping(string => bool) public flaggedMixers;
    mapping(string => uint256) public aprDisruptionScore;

    event MixerDetected(string mixer, uint256 aprScore, uint timestamp);

    function detectMixer(string memory mixer, uint256 aprScore) public {
        flaggedMixers[mixer] = true;
        aprDisruptionScore[mixer] = aprScore;
        emit MixerDetected(mixer, aprScore, block.timestamp);
    }

    function isFlagged(string memory mixer) public view returns (bool) {
        return flaggedMixers[mixer];
    }

    function getAPRScore(string memory mixer) public view returns (uint256) {
        return aprDisruptionScore[mixer];
    }
}
