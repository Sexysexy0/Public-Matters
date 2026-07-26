// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CorruptionBlacklist {
    mapping(address => bool) public isBlacklisted;

    // [Permanent Ban for Corrupt Entities]
    function flagContractor(address _contractor) external {
        // Logic: Once blacklisted, they cannot interact with any Public Works Contract.
        isBlacklisted[_contractor] = true;
    }
}
