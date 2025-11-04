// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DrainageSystemRestitutionDAO {
    address public steward;

    struct RestitutionEntry {
        string systemLocation;
        string restitutionSignal;
        string communityMetric;
        string emotionalTag;
    }

    RestitutionEntry[] public registry;

    event DrainageRestituted(string systemLocation, string restitutionSignal, string communityMetric, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function restituteDrainage(
        string memory systemLocation,
        string memory restitutionSignal,
        string memory communityMetric,
        string memory emotionalTag
    ) public onlySteward {
        registry.push(RestitutionEntry(systemLocation, restitutionSignal, communityMetric, emotionalTag));
        emit DrainageRestituted(systemLocation, restitutionSignal, communityMetric, emotionalTag);
    }
}
