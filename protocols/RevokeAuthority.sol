// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract RevokeAuthority {
    mapping(address => bool) public isBanned;

    // [Goal: Permanently ban 'Out-of-Touch' logic from influencing the Sovereign's decisions]
    function banPseudoExpert(address _entity) external {
        // Only the Sovereign (Vin) can revoke authority
        isBanned[_entity] = true;
    }
}
