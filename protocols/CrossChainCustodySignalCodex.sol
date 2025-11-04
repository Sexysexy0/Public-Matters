// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CrossChainCustodySignalCodex {
    address public steward;

    struct CustodySignal {
        string chainName;
        string custodyProvider;
        string interoperabilitySignal;
        string emotionalTag;
    }

    CustodySignal[] public codex;

    event CrossChainCustodyTagged(string chainName, string custodyProvider, string interoperabilitySignal, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function tagCustodySignal(
        string memory chainName,
        string memory custodyProvider,
        string memory interoperabilitySignal,
        string memory emotionalTag
    ) public onlySteward {
        codex.push(CustodySignal(chainName, custodyProvider, interoperabilitySignal, emotionalTag));
        emit CrossChainCustodyTagged(chainName, custodyProvider, interoperabilitySignal, emotionalTag);
    }
}
