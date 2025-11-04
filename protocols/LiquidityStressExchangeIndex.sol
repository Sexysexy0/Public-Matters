// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LiquidityStressExchangeIndex {
    address public steward;

    struct StressEntry {
        string exchangeName;
        string stressScenario;
        string resilienceSignal;
        string emotionalTag;
    }

    StressEntry[] public index;

    event LiquidityStressTagged(string exchangeName, string stressScenario, string resilienceSignal, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function tagStress(
        string memory exchangeName,
        string memory stressScenario,
        string memory resilienceSignal,
        string memory emotionalTag
    ) public onlySteward {
        index.push(StressEntry(exchangeName, stressScenario, resilienceSignal, emotionalTag));
        emit LiquidityStressTagged(exchangeName, stressScenario, resilienceSignal, emotionalTag);
    }
}
