// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title LegendaryFallback
/// @dev Activates emergency reroute when civic backbone fails

contract LegendaryFallback {
    address public steward;
    mapping(address => bool) public rerouteTriggered;

    event FallbackActivated(address indexed failedLeader, string reason);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function activateFallback(address failedLeader, string memory reason) public onlySteward {
        rerouteTriggered[failedLeader] = true;
        emit FallbackActivated(failedLeader, reason);
    }

    function checkFallback(address leader) public view returns (bool) {
        return rerouteTriggered[leader];
    }
}
