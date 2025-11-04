// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ExportBanSimulationCodex {
    address public steward;

    struct BanEntry {
        string assetType;
        string targetCountry;
        string simulatedImpact;
        string emotionalTag;
    }

    BanEntry[] public codex;

    event ExportBanSimulated(string assetType, string targetCountry, string simulatedImpact, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function simulateBan(
        string memory assetType,
        string memory targetCountry,
        string memory simulatedImpact,
        string memory emotionalTag
    ) public onlySteward {
        codex.push(BanEntry(assetType, targetCountry, simulatedImpact, emotionalTag));
        emit ExportBanSimulated(assetType, targetCountry, simulatedImpact, emotionalTag);
    }
}
