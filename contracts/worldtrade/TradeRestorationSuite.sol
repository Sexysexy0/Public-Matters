// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./BitMarketLiquidityFeed.sol";
import "./VendorBlessingProtocol.sol";
import "./BarangayFallbackRouter.sol";
import "./TradeTelemetry.sol";
import "./TradePeaceTreaty.sol";

contract TradeRestorationSuite {
    BitMarketLiquidityFeed public liquidityFeed;
    VendorBlessingProtocol public vendorBlessing;
    BarangayFallbackRouter public fallbackRouter;
    TradeTelemetry public telemetry;
    TradePeaceTreaty public treaty;

    constructor(
        address _liquidityFeed,
        address _vendorBlessing,
        address _fallbackRouter,
        address _telemetry,
        address _treaty
    ) {
        liquidityFeed = BitMarketLiquidityFeed(_liquidityFeed);
        vendorBlessing = VendorBlessingProtocol(_vendorBlessing);
        fallbackRouter = BarangayFallbackRouter(_fallbackRouter);
        telemetry = TradeTelemetry(_telemetry);
        treaty = TradePeaceTreaty(_treaty);
    }

    function blessTradeLoop(
        string memory asset,
        uint256 emotionalAPR,
        uint256 tradeVolume,
        string memory vendorTag,
        string memory fallbackTrigger,
        string memory fallbackDestination,
        string memory treatyCountryA,
        string memory treatyCountryB,
        string memory blessingClause
    ) public {
        liquidityFeed.logSignal(asset, emotionalAPR, tradeVolume, vendorTag);
        fallbackRouter.routeFallback(msg.sender, fallbackTrigger, fallbackDestination, emotionalAPR);
        vendorBlessing.blessVendor(msg.sender, vendorTag, "BlessedVendor", emotionalAPR);
        telemetry.logSignal("Scrollchain", string(abi.encodePacked("Blessed trade loop for ", asset)), emotionalAPR, "TradeSurge");
        treaty.blessTreaty(treatyCountryA, treatyCountryB, emotionalAPR, blessingClause);
    }
}
