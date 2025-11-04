// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract InstitutionalFlowAnchoringDAO {
    address public steward;

    struct FlowEntry {
        string capitalSource;
        string ETFImpact;
        string anchoringSignal;
        string emotionalTag;
    }

    FlowEntry[] public registry;

    event InstitutionalFlowAnchored(string capitalSource, string ETFImpact, string anchoringSignal, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function anchorFlow(
        string memory capitalSource,
        string memory ETFImpact,
        string memory anchoringSignal,
        string memory emotionalTag
    ) public onlySteward {
        registry.push(FlowEntry(capitalSource, ETFImpact, anchoringSignal, emotionalTag));
        emit InstitutionalFlowAnchored(capitalSource, ETFImpact, anchoringSignal, emotionalTag);
    }
}
