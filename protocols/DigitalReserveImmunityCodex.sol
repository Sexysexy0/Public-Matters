// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DigitalReserveImmunityCodex {
    address public steward;

    struct ImmunityEntry {
        string assetName;
        string centralizationThreat;
        string immunitySignal;
        string emotionalTag;
    }

    ImmunityEntry[] public codex;

    event DigitalReserveImmunityTagged(string assetName, string centralizationThreat, string immunitySignal, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function tagImmunity(
        string memory assetName,
        string memory centralizationThreat,
        string memory immunitySignal,
        string memory emotionalTag
    ) public onlySteward {
        codex.push(ImmunityEntry(assetName, centralizationThreat, immunitySignal, emotionalTag));
        emit DigitalReserveImmunityTagged(assetName, centralizationThreat, immunitySignal, emotionalTag);
    }
}
