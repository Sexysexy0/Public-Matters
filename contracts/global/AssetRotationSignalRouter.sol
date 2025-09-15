// SPDX-License-Identifier: RotationSanctum
pragma solidity ^0.8.19;

contract AssetRotationSignalRouter {
    struct RotationSignal {
        address asset;
        string assetType; // e.g., "Altcoin", "ETF-backed", "Stablecoin"
        uint256 liquidityScore;
        bool rotatingToETF;
        string macroNarrative;
        string stewardNote;
    }

    mapping(address => RotationSignal) public signals;

    event RotationTagged(address asset, string assetType);
    event RotationConfirmed(address asset);

    function tagRotation(address asset, string memory assetType, uint256 liquidityScore, bool rotatingToETF, string memory macroNarrative, string memory stewardNote) public {
        signals[asset] = RotationSignal(asset, assetType, liquidityScore, rotatingToETF, macroNarrative, stewardNote);
        emit RotationTagged(asset, assetType);
    }

    function confirmRotation(address asset) public {
        signals[asset].rotatingToETF = true;
        emit RotationConfirmed(asset);
    }

    function getRotationStatus(address asset) public view returns (RotationSignal memory) {
        return signals[asset];
    }
}
