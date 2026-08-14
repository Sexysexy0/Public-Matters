// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface ITrustIntegrator {
    function logPositiveAction(string memory action, uint256 weight) external;
    function logSetback(string memory action, uint256 weight) external;
}
