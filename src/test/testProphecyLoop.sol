// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import {ProphecyLoop} from "../../contracts/telemetry/ProphecyLoop.sol";

contract ProphecyLoopTest is Test {
    ProphecyLoop loop;

    function setUp() public {
        loop = new ProphecyLoop();
    }

    function testLogOmen() public {
        loop.logOmen("HopeSurge", "JoySpike");
        assertEq(loop.omenCounter(), 1);
    }

    function testDetectSpike() public {
        loop.detectSpike("SocialFeed", 88, "EmpathySurge");
        ProphecyLoop.Spike memory spike = loop.getSpike(0);
        assertEq(spike.intensity, 88);
        assertEq(spike.signalSource, "SocialFeed");
        assertEq(spike.APRtag, "EmpathySurge");
    }

    function testMultipleOmensAndSpikes() public {
        loop.logOmen("FearDip", "AnxietyWave");
        loop.logOmen("ClarityPing", "PeacePulse");
        loop.detectSpike("TarotFeed", 42, "TrustEcho");
        loop.detectSpike("GeoSignal", 99, "ResonancePeak");

        assertEq(loop.omenCounter(), 2);
        assertEq(loop.spikeCounter(), 2);
    }
}
