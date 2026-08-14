// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface ITrustIntegrator {
    function logPositiveAction(address actor, uint256 weight) external;
}
