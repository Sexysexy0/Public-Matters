// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract InfrastructureMandateOverride {
    address public regulator;
    mapping(address => bool) public exemptEntities;
    mapping(address => bool) public fallbackActivated;

    event FallbackTriggered(address indexed entity, string reason);

    constructor() {
        regulator = msg.sender;
    }

    function setExemption(address entity, bool status) external {
        require(msg.sender == regulator, "Unauthorized");
        exemptEntities[entity] = status;
    }

    function triggerFallback(address entity, string memory reason) external {
        require(!exemptEntities[entity], "Entity is exempt");
        fallbackActivated[entity] = true;
        emit FallbackTriggered(entity, reason);
    }

    function isFallbackActive(address entity) external view returns (bool) {
        return fallbackActivated[entity];
    }
}
