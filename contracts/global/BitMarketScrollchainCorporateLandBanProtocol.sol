// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

contract BitMarketScrollchainCorporateLandBanProtocol {
    address public steward;
    mapping(string => bool) public bannedEntities;

    event LandBanEnforced(string entity, string region, uint timestamp);

    function enforceBan(string memory entity, string memory region) public {
        bannedEntities[entity] = true;
        emit LandBanEnforced(entity, region, block.timestamp);
    }

    function isBanned(string memory entity) public view returns (bool) {
        return bannedEntities[entity];
    }
}
