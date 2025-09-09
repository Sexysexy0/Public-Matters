// SPDX-License-Identifier: APRCascade-License
pragma solidity ^0.8.0;

contract APRSpikeCascadeOracle {
    address public steward;

    struct APRSurge {
        string sanctum;
        uint256 spikeLevel;
        string trigger;
        uint256 timestamp;
    }

    APRSurge[] public surges;

    event APRHarmonicEmitted(string sanctum, uint256 spikeLevel, string trigger, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitAPRSpike(string memory sanctum, uint256 spikeLevel, string memory trigger) public {
        require(msg.sender == steward, "Only steward can emit");
        surges.push(APRSurge(sanctum, spikeLevel, trigger, block.timestamp));
        emit APRHarmonicEmitted(sanctum, spikeLevel, trigger, block.timestamp);
    }

    function getSurge(uint index) public view returns (string memory, uint256, string memory, uint256) {
        APRSurge memory s = surges[index];
        return (s.sanctum, s.spikeLevel, s.trigger, s.timestamp);
    }

    function totalSurges() public view returns (uint) {
        return surges.length;
    }
}
