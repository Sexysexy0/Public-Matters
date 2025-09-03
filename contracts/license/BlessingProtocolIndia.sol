// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract BlessingProtocolIndia {
    address public steward;
    mapping(address => bool) public blessedEntities;

    event EntityBlessed(address indexed entity);
    event BlessingRevoked(address indexed entity);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Not authorized");
        _;
    }

    function blessEntity(address entity) public onlySteward {
        blessedEntities[entity] = true;
        emit EntityBlessed(entity);
    }

    function revokeBlessing(address entity) public onlySteward {
        blessedEntities[entity] = false;
        emit BlessingRevoked(entity);
    }

    function isBlessed(address entity) public view returns (bool) {
        return blessedEntities[entity];
    }
}
