// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LightningNetworkResilienceCodex {
    address public steward;

    struct ResilienceEntry {
        string region;
        string stressScenario;
        string resilienceMetric;
        string emotionalTag;
    }

    ResilienceEntry[] public codex;

    event LightningResilienceTagged(string region, string stressScenario, string resilienceMetric, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function tagResilience(
        string memory region,
        string memory stressScenario,
        string memory resilienceMetric,
        string memory emotionalTag
    ) public onlySteward {
        codex.push(ResilienceEntry(region, stressScenario, resilienceMetric, emotionalTag));
        emit LightningResilienceTagged(region, stressScenario, resilienceMetric, emotionalTag);
    }
}
