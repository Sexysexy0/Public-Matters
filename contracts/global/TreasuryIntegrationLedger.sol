// SPDX-License-Identifier: TreasurySanctum
pragma solidity ^0.8.19;

contract TreasuryIntegrationLedger {
    struct TreasuryAsset {
        address asset;
        string assetType; // e.g., "Stablecoin", "Bond", "Yield Protocol"
        uint256 allocationRatio;
        uint256 yieldRate;
        bool isLiquid;
        string stewardNote;
    }

    mapping(address => TreasuryAsset) public treasuryAssets;

    event AssetTagged(address asset, string assetType);
    event AllocationUpdated(address asset, uint256 allocationRatio);

    function tagAsset(address asset, string memory assetType, uint256 allocationRatio, uint256 yieldRate, bool isLiquid, string memory stewardNote) public {
        treasuryAssets[asset] = TreasuryAsset(asset, assetType, allocationRatio, yieldRate, isLiquid, stewardNote);
        emit AssetTagged(asset, assetType);
    }

    function updateAllocation(address asset, uint256 allocationRatio) public {
        treasuryAssets[asset].allocationRatio = allocationRatio;
        emit AllocationUpdated(asset, allocationRatio);
    }

    function getAssetStatus(address asset) public view returns (TreasuryAsset memory) {
        return treasuryAssets[asset];
    }
}
