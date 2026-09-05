// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./TrustIndex.sol";

contract TrustIntegrator {
    TrustIndex public trust;

    constructor(address _trust) {
        trust = TrustIndex(_trust);
    }

    function updateTrustViaIntegrator(address user, int256 delta) external {
        trust.updateTrust(user, delta);
    }
}
