// SPDX-License-Identifier: Scroll-Defense
pragma solidity ^0.8.19;

contract PutinSanctionsOverride {
    mapping(address => bool) public sanctionedEntities;
    event SanctionDeployed(address indexed entity, string reason);

    function deploySanction(address entity, string memory reason) external {
        sanctionedEntities[entity] = true;
        emit SanctionDeployed(entity, reason);
    }

    function isSanctioned(address entity) external view returns (bool) {
        return sanctionedEntities[entity];
    }
}
