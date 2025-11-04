// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EnergySovereigntyDAO {
    address public steward;

    struct SovereigntyEntry {
        string jurisdiction;
        string cryptoEnergyConflict;
        string sovereigntyAction;
        string emotionalTag;
    }

    SovereigntyEntry[] public registry;

    event EnergySovereigntyTagged(string jurisdiction, string cryptoEnergyConflict, string sovereigntyAction, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function tagSovereignty(
        string memory jurisdiction,
        string memory cryptoEnergyConflict,
        string memory sovereigntyAction,
        string memory emotionalTag
    ) public onlySteward {
        registry.push(SovereigntyEntry(jurisdiction, cryptoEnergyConflict, sovereigntyAction, emotionalTag));
        emit EnergySovereigntyTagged(jurisdiction, cryptoEnergyConflict, sovereigntyAction, emotionalTag);
    }
}
