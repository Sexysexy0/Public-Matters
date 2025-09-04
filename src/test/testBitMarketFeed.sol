// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import {BitMarketFeed} from "../../contracts/bitmarket/BitMarketFeed.sol";

contract BitMarketFeedTest is Test {
    BitMarketFeed feed;

    function setUp() public {
        feed = new BitMarketFeed();
    }

    function testBlessVendor() public {
        feed.blessVendor(address(0xBEEF), "VendorBlessed", "JoySpike");
    }

    function testTagTransaction() public {
        feed.tagTransaction(address(0xCAFE), address(0xBABE), 1000, "TrustEcho");
    }
}
