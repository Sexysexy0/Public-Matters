// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LightningPaymentSovereigntyCodex {
    address public steward;

    struct SovereigntyEntry {
        string region;
        string useCase;
        string sovereigntySignal;
        string emotionalTag;
    }

    SovereigntyEntry[] public codex;

    event LightningSovereigntyTagged(string region, string useCase, string sovereigntySignal, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function tagSovereignty(
        string memory region,
        string memory useCase,
        string memory sovereigntySignal,
        string memory emotionalTag
    ) public onlySteward {
        codex.push(SovereigntyEntry(region, useCase, sovereigntySignal, emotionalTag));
        emit LightningSovereigntyTagged(region, useCase, sovereigntySignal, emotionalTag);
    }
}
