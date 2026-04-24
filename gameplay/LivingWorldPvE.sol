// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract LivingWorldPvE {
    // [Goal: Foster community through shared challenges]
    function joinRaid(string memory _boss) external pure returns (string memory) {
        return string(abi.encodePacked("CO-OP_SYNC: Defending the East against ", _boss));
    }
}
