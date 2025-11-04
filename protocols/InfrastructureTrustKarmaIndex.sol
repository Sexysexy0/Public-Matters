// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract InfrastructureTrustKarmaIndex {
    address public steward;

    struct KarmaEntry {
        string region;
        string trustSignal;
        string karmaWeight;
        string emotionalTag;
    }

    KarmaEntry[] public index;

    event InfrastructureKarmaIndexed(string region, string trustSignal, string karmaWeight, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function indexKarma(
        string memory region,
        string memory trustSignal,
        string memory karmaWeight,
        string memory emotionalTag
    ) public onlySteward {
        index.push(KarmaEntry(region, trustSignal, karmaWeight, emotionalTag));
        emit InfrastructureKarmaIndexed(region, trustSignal, karmaWeight, emotionalTag);
    }
}
