// SPDX-License-Identifier: ResilienceSanctum
pragma solidity ^0.8.19;

contract MacroResilienceLedger {
    struct ResilienceEntry {
        address asset;
        string macroRiskType; // e.g., "Liquidity Crunch", "Rate Hike", "Election Shock"
        uint256 stressScore;
        bool hasStablecoinBuffer;
        bool ETFProtected;
        string stewardNote;
    }

    mapping(address => ResilienceEntry) public entries;

    event ResilienceTagged(address asset, string macroRiskType);
    event BufferConfirmed(address asset);

    function tagResilience(address asset, string memory macroRiskType, uint256 stressScore, bool hasStablecoinBuffer, bool ETFProtected, string memory stewardNote) public {
        entries[asset] = ResilienceEntry(asset, macroRiskType, stressScore, hasStablecoinBuffer, ETFProtected, stewardNote);
        emit ResilienceTagged(asset, macroRiskType);
    }

    function confirmBuffer(address asset) public {
        entries[asset].hasStablecoinBuffer = true;
        emit BufferConfirmed(asset);
    }

    function getResilienceStatus(address asset) public view returns (ResilienceEntry memory) {
        return entries[asset];
    }
}
