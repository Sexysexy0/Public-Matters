// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SocialReputation {
    mapping(address => int256) public reputation;

    // [Goal: Manage the Sovereign's social standing to minimize systemic friction]
    function reportAction(address _entity, int256 _impact) external {
        reputation[_entity] += _impact;
    }
}
