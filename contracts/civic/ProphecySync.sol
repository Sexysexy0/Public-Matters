// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ProphecySync {
    struct Prophecy {
        string region;
        string predictedEvent;
        uint256 forecastTimestamp;
        uint256 confidenceLevel; // 0–100
    }

    mapping(bytes32 => Prophecy) public prophecies;
    event ProphecyLogged(bytes32 indexed regionId, string predictedEvent, uint256 confidenceLevel);

    function logProphecy(string memory region, string memory predictedEvent, uint256 confidenceLevel) public {
        bytes32 regionId = keccak256(abi.encodePacked(region));
        prophecies[regionId] = Prophecy(region, predictedEvent, block.timestamp, confidenceLevel);
        emit ProphecyLogged(regionId, predictedEvent, confidenceLevel);
    }

    function getProphecy(string memory region) public view returns (Prophecy memory) {
        bytes32 regionId = keccak256(abi.encodePacked(region));
        return prophecies[regionId];
    }
}
