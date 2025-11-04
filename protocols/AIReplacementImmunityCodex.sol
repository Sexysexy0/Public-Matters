// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AIReplacementImmunityCodex {
    address public steward;

    struct ImmunityEntry {
        string jobRole;
        string immunitySignal;
        string resilienceMechanism;
        string emotionalTag;
    }

    ImmunityEntry[] public codex;

    event AIImmunityTagged(string jobRole, string immunitySignal, string resilienceMechanism, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function tagImmunity(
        string memory jobRole,
        string memory immunitySignal,
        string memory resilienceMechanism,
        string memory emotionalTag
    ) public onlySteward {
        codex.push(ImmunityEntry(jobRole, immunitySignal, resilienceMechanism, emotionalTag));
        emit AIImmunityTagged(jobRole, immunitySignal, resilienceMechanism, emotionalTag);
    }
}
