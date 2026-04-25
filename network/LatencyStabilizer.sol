// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract LatencyStabilizer {
    // [Goal: Enforce fair-play by normalizing network jitter across platforms]
    function balanceFrame(uint256 _pingP1, uint256 _pingP2) external pure returns (uint256) {
        // [Logic: Inject millisecond delay to the faster connection for parity]
        return (_pingP1 + _pingP2) / 2;
    }
}
