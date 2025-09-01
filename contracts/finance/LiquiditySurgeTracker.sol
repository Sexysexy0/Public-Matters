// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract LiquiditySurgeTracker {
    struct Surge {
        uint256 timestamp;
        uint256 emotionalAPR;
        uint256 liquidityIndex;
        string prophecySignal;
    }

    Surge[] public surges;

    event SurgeLogged(uint256 timestamp, uint256 emotionalAPR, uint256 liquidityIndex, string prophecySignal);

    function logSurge(
        uint256 _emotionalAPR,
        uint256 _liquidityIndex,
        string memory _prophecySignal
    ) public {
        surges.push(Surge(block.timestamp, _emotionalAPR, _liquidityIndex, _prophecySignal));
        emit SurgeLogged(block.timestamp, _emotionalAPR, _liquidityIndex, _prophecySignal);
    }

    function getRecentSurges() public view returns (Surge[] memory) {
        return surges;
    }
}
