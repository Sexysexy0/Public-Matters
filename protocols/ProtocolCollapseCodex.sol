// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ProtocolCollapseCodex {
    address public steward;

    struct CollapseEntry {
        string protocolName;
        string collapseTrigger;
        string systemicImpact;
        string emotionalTag;
    }

    CollapseEntry[] public codex;

    event ProtocolCollapseLogged(string protocolName, string collapseTrigger, string systemicImpact, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function logCollapse(
        string memory protocolName,
        string memory collapseTrigger,
        string memory systemicImpact,
        string memory emotionalTag
    ) public onlySteward {
        codex.push(CollapseEntry(protocolName, collapseTrigger, systemicImpact, emotionalTag));
        emit ProtocolCollapseLogged(protocolName, collapseTrigger, systemicImpact, emotionalTag);
    }
}
