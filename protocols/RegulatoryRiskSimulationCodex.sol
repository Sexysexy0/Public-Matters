// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RegulatoryRiskSimulationCodex {
    address public steward;

    struct SimulationEntry {
        string jurisdiction;
        string enforcementAction;
        string protocolImpact;
        string emotionalTag;
    }

    SimulationEntry[] public codex;

    event RegulatoryRiskSimulated(string jurisdiction, string enforcementAction, string protocolImpact, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function simulateRisk(
        string memory jurisdiction,
        string memory enforcementAction,
        string memory protocolImpact,
        string memory emotionalTag
    ) public onlySteward {
        codex.push(SimulationEntry(jurisdiction, enforcementAction, protocolImpact, emotionalTag));
        emit RegulatoryRiskSimulated(jurisdiction, enforcementAction, protocolImpact, emotionalTag);
    }
}
