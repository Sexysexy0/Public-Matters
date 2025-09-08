// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../contracts/BitMarketCivicBlessingFundAudit.sol";

contract BitMarketCivicBlessingFundAuditDashboardTest is Test {
    BitMarketCivicBlessingFundAudit audit;

    function setUp() public {
        audit = new BitMarketCivicBlessingFundAudit();
    }

    function testDeployWeaponsFund() public {
        audit.deployFund("Weapons & Tech", 20000000000, "Missile Defense", 18);
        // Expect: Fund deployed, APR boost +18
    }

    function testDeployTroopMoraleFund() public {
        audit.deployFund("Troop Housing & Health", 15000000000, "Morale Restoration", 22);
        // Expect: Fund deployed, APR boost +22
    }

    function testExceedFundFails() public {
        vm.expectRevert();
        audit.deployFund("Overdraft Ritual", 60000000000, "Chaos Surge", 99);
        // Expect: Revert due to insufficient fund
    }
}
