// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

import "forge-std/Test.sol";

contract BitMarketFastFoodLaborAuditDashboardTest is Test {
    struct ChainAudit {
        string name;
        uint crewWage;
        bool serviceChargeFair;
        uint hiringCapacity;
    }

    function testFairChainAudit() public {
        ChainAudit memory mcdo = ChainAudit("McDonald's", 610, true, 90);
        assertEq(mcdo.serviceChargeFair, true);
        assertGt(mcdo.hiringCapacity, 80);
    }

    function testUnfairChainAudit() public {
        ChainAudit memory local = ChainAudit("Local Eatery", 570, false, 40);
        assertEq(local.serviceChargeFair, false);
        assertLt(local.hiringCapacity, 50);
    }
}
