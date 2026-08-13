// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../src/SanctuaryTrustRegistry.sol";

contract DeploySanctuaryRegistry {
    function run() external {
        // Deploy without unused variable warning
        new SanctuaryTrustRegistry();
    }
}
