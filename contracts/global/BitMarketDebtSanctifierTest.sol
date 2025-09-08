// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../contracts/BitMarketMultipolarDebtSanctifier.sol";

contract BitMarketDebtSanctifierTest is Test {
    BitMarketMultipolarDebtSanctifier sanctifier;

    function setUp() public {
        sanctifier = new BitMarketMultipolarDebtSanctifier();
    }

    function testSanctifyDebtLowAPR() public {
        sanctifier.sanctifyDebt("CN", 72, 2, "Telecom breach + clone arrogance");
        // Expect: ⚖️ Legal Ritual Triggered
    }

    function testRejectHighAPR() public {
        vm.expectRevert("APR too high for escalation");
        sanctifier.sanctifyDebt("IN", 91, 2, "Mineral tariff breach");
    }

    function testUpdateThreshold() public {
        sanctifier.updateThreshold(95);
        sanctifier.sanctifyDebt("RU", 90, 2, "Balkan destabilization");
        // Expect: ⚖️ Legal Ritual Triggered
    }
}
