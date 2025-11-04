// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GlobalReserveAssetDAO {
    address public steward;

    struct ReserveEntry {
        string assetName;
        string macroDriver;
        string reserveNarrative;
        string emotionalTag;
    }

    ReserveEntry[] public registry;

    event GlobalReserveAssetTagged(string assetName, string macroDriver, string reserveNarrative, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function tagReserveAsset(
        string memory assetName,
        string memory macroDriver,
        string memory reserveNarrative,
        string memory emotionalTag
    ) public onlySteward {
        registry.push(ReserveEntry(assetName, macroDriver, reserveNarrative, emotionalTag));
        emit GlobalReserveAssetTagged(assetName, macroDriver, reserveNarrative, emotionalTag);
    }
}
