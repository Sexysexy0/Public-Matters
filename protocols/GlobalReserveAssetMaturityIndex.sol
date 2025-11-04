// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GlobalReserveAssetMaturityIndex {
    address public steward;

    struct MaturityEntry {
        string assetName;
        string maturitySignal;
        string institutionalMetric;
        string emotionalTag;
    }

    MaturityEntry[] public index;

    event ReserveAssetMaturityTagged(string assetName, string maturitySignal, string institutionalMetric, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function tagMaturity(
        string memory assetName,
        string memory maturitySignal,
        string memory institutionalMetric,
        string memory emotionalTag
    ) public onlySteward {
        index.push(MaturityEntry(assetName, maturitySignal, institutionalMetric, emotionalTag));
        emit ReserveAssetMaturityTagged(assetName, maturitySignal, institutionalMetric, emotionalTag);
    }
}
