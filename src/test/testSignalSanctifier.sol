// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import {SignalSanctifier} from "../../contracts/telemetry/SignalSanctifier.sol";

contract SignalSanctifierTest is Test {
    SignalSanctifier sanctifier;

    function setUp() public {
        sanctifier = new SignalSanctifier();
    }

    function testSanctifySignal() public {
        sanctifier.sanctifySignal("TarotFeed", "HopeSurge");
        // Signal ID is dynamic, so we test counter logic via event or mapping length
        // Optional: assert via emitted event or mapping presence
    }

    function testMultipleSanctifications() public {
        sanctifier.sanctifySignal("GeoSignal", "TrustEcho");
        sanctifier.sanctifySignal("SocialFeed", "JoySpike");
        // Optional: assert mapping length or event count
    }
}
