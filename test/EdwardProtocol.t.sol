// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/EdwardProtocol.sol";

contract EdwardProtocolTest is Test {
    EdwardProtocol edward;
    address payable crewMember = payable(address(0x4040));
    bytes32 fleetId = keccak256("JACKDAW_FLEET_1");

    function setUp() public {
        edward = new EdwardProtocol{value: 2 ether}();
    }

    function test_CommissionFleet() public {
        edward.commissionFleet(fleetId, "Havana-Nassau Route");
        assertTrue(edward.activeFleets(fleetId));
    }

    function test_DistributePlunder() public {
        uint256 balanceBefore = crewMember.balance;
        edward.distributePlunder(crewMember, 0.5 ether);
        
        assertEq(crewMember.balance, balanceBefore + 0.5 ether);
        assertEq(edward.jackdawTreasury(crewMember), 0.5 ether);
    }

    function test_RevertWhenNonCaptainCalls() public {
        vm.prank(crewMember);
        vm.expectRevert("Unauthorized: Only the Master Captain can command this.");
        edward.commissionFleet(fleetId, "Unauthorized Route");
    }
}
