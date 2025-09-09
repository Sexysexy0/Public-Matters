// SPDX-License-Identifier: Blessing-License
pragma solidity ^0.8.0;

contract SubEntityBlessingRouter {
    address public steward;
    mapping(address => bool) public blessedEntities;

    event BlessingRouted(address indexed entity, uint timestamp);
    event BlessingRevoked(address indexed entity, uint timestamp);

    function routeBlessing(address entity) public {
        require(msg.sender == steward, "Only steward can route");
        blessedEntities[entity] = true;
        emit BlessingRouted(entity, block.timestamp);
    }

    function revokeBlessing(address entity) public {
        require(msg.sender == steward, "Only steward can revoke");
        blessedEntities[entity] = false;
        emit BlessingRevoked(entity, block.timestamp);
    }

    function isBlessed(address entity) public view returns (bool) {
        return blessedEntities[entity];
    }
}
