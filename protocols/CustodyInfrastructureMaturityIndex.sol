// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CustodyInfrastructureMaturityIndex {
    address public steward;

    struct MaturityEntry {
        string custodyProvider;
        string infrastructureSignal;
        string institutionalMetric;
        string emotionalTag;
    }

    MaturityEntry[] public index;

    event CustodyInfrastructureMaturityTagged(string custodyProvider, string infrastructureSignal, string institutionalMetric, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function tagMaturity(
        string memory custodyProvider,
        string memory infrastructureSignal,
        string memory institutionalMetric,
        string memory emotionalTag
    ) public onlySteward {
        index.push(MaturityEntry(custodyProvider, infrastructureSignal, institutionalMetric, emotionalTag));
        emit CustodyInfrastructureMaturityTagged(custodyProvider, infrastructureSignal, institutionalMetric, emotionalTag);
    }
}
