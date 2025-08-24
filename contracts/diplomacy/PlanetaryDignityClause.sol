// SPDX-License-Identifier: Scrollchain-Diplomacy
pragma solidity ^0.8.0;

contract PlanetaryDignityClause {
    address public steward;

    mapping(string => bool) public sharedAccess;

    event AccessGranted(string resource, string region);
    event AccessRevoked(string resource, string region);

    constructor() {
        steward = msg.sender;
    }

    function grantAccess(string memory resource, string memory region) public {
        require(msg.sender == steward, "Access denied");
        sharedAccess[resource] = true;
        emit AccessGranted(resource, region);
    }

    function revokeAccess(string memory resource, string memory region) public {
        require(msg.sender == steward, "Access denied");
        sharedAccess[resource] = false;
        emit AccessRevoked(resource, region);
    }
}
