// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GlobalCustodyTrustFramework {
    address public steward;

    struct TrustEntry {
        string custodyProvider;
        string jurisdiction;
        string trustSignal;
        string emotionalTag;
    }

    TrustEntry[] public framework;

    event CustodyTrustTagged(string custodyProvider, string jurisdiction, string trustSignal, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function tagTrust(
        string memory custodyProvider,
        string memory jurisdiction,
        string memory trustSignal,
        string memory emotionalTag
    ) public onlySteward {
        framework.push(TrustEntry(custodyProvider, jurisdiction, trustSignal, emotionalTag));
        emit CustodyTrustTagged(custodyProvider, jurisdiction, trustSignal, emotionalTag);
    }
}
