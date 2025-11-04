// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ProtocolResurrectionIndex {
    address public steward;

    struct ResurrectionEntry {
        string protocolName;
        string collapseCause;
        string resurrectionSignal;
        string emotionalTag;
    }

    ResurrectionEntry[] public index;

    event ProtocolResurrectionIndexed(string protocolName, string collapseCause, string resurrectionSignal, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function indexResurrection(
        string memory protocolName,
        string memory collapseCause,
        string memory resurrectionSignal,
        string memory emotionalTag
    ) public onlySteward {
        index.push(ResurrectionEntry(protocolName, collapseCause, resurrectionSignal, emotionalTag));
        emit ProtocolResurrectionIndexed(protocolName, collapseCause, resurrectionSignal, emotionalTag);
    }
}
