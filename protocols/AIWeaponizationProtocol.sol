// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AIWeaponizationProtocol {
    address public steward;

    struct WeaponizationEntry {
        string AIProvider;
        string useCase;
        string geopoliticalImpact;
        string emotionalTag;
    }

    WeaponizationEntry[] public registry;

    event AIWeaponizationTagged(string AIProvider, string useCase, string geopoliticalImpact, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function tagWeaponization(
        string memory AIProvider,
        string memory useCase,
        string memory geopoliticalImpact,
        string memory emotionalTag
    ) public onlySteward {
        registry.push(WeaponizationEntry(AIProvider, useCase, geopoliticalImpact, emotionalTag));
        emit AIWeaponizationTagged(AIProvider, useCase, geopoliticalImpact, emotionalTag);
    }
}
