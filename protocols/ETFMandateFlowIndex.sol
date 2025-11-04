// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ETFMandateFlowIndex {
    address public steward;

    struct FlowEntry {
        string ETFName;
        string mandateType;
        string flowSignal;
        string emotionalTag;
    }

    FlowEntry[] public index;

    event ETFMandateFlowTagged(string ETFName, string mandateType, string flowSignal, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function tagFlow(
        string memory ETFName,
        string memory mandateType,
        string memory flowSignal,
        string memory emotionalTag
    ) public onlySteward {
        index.push(FlowEntry(ETFName, mandateType, flowSignal, emotionalTag));
        emit ETFMandateFlowTagged(ETFName, mandateType, flowSignal, emotionalTag);
    }
}
