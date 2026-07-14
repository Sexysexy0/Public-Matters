// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import "../contracts/BitMarketVPNObfuscationAuditProtocol.sol";

contract BitMarketVPNObfuscationAuditProtocolTest is Test {
    BitMarketVPNObfuscationAuditProtocol audit;

    function setUp() public {
        audit = new BitMarketVPNObfuscationAuditProtocol();
    }

    function testDetectVPNAndProxy() public {
        audit.auditTunnel("China", true, true);
        // Expect: 🔥 Cloaked Route Detected
    }

    function testCleanChannel() public {
        audit.auditTunnel("Philippines", false, false);
        // Expect: ✅ Clean Channel
    }

    function testPartialDetection() public {
        audit.auditTunnel("Russia", true, false);
        // Expect: 🔥 Cloaked Route Detected
    }
}
