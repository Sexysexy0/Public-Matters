// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../contracts/BitMarketTrustAnchorSanctifier.sol";

contract BitMarketUnicodeFirewallTest is Test {
    BitMarketTrustAnchorSanctifier sanctifier;

    function setUp() public {
        sanctifier = new BitMarketTrustAnchorSanctifier();
    }

    function testValidEmailAnchor() public {
        bool result = sanctifier.validateEmailAnchor("vinvin@example.com");
        assertTrue(result);
    }

    function testConfusableEmailAnchor() public {
        bool result = sanctifier.validateEmailAnchor("vіnvіn@exаmple.com"); // Cyrillic ‘і’ and ‘а’
        assertFalse(result);
    }

    function testFullWidthSpoof() public {
        bool result = sanctifier.validateEmailAnchor("vｉｎｖｉｎ@ｅｘａｍｐｌｅ.com"); // Full-width characters
        assertFalse(result);
    }
}
