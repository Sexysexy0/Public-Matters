// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface ITrustIntegrator {
    function logPositiveAction(uint256 _weight) external;
}
