// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CustodyUXCodex {
    address public steward;

    struct UXEntry {
        string custodyType;
        string UXChallenge;
        string resilienceSignal;
        string emotionalTag;
    }

    UXEntry[] public codex;

    event CustodyUXTagged(string custodyType, string UXChallenge, string resilienceSignal, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function tagUX(
        string memory custodyType,
        string memory UXChallenge,
        string memory resilienceSignal,
        string memory emotionalTag
    ) public onlySteward {
        codex.push(UXEntry(custodyType, UXChallenge, resilienceSignal, emotionalTag));
        emit CustodyUXTagged(custodyType, UXChallenge, resilienceSignal, emotionalTag);
    }
}
