// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/CivicBillClearingRegistry.sol";

contract CivicBillClearingRegistryTest is Test {
    CivicBillClearingRegistry registry;
    address sovereign = address(this);
    address donor = address(0x123);
    address payable beneficiary = payable(address(0x456));

    event BillRegistered(uint256 indexed id, address indexed beneficiary, uint256 amount, string billType);
    event BillCleared(uint256 indexed id, address indexed donor, uint256 amount);

    function setUp() public {
        registry = new CivicBillClearingRegistry();
        vm.deal(sovereign, 10 ether);
        vm.deal(donor, 10 ether);
    }

    function test_RegisterBill() public {
        uint256 amount = 1 ether;
        string memory billType = "UTILITY";

        vm.expectEmit(true, true, false, true);
        emit BillRegistered(1, beneficiary, amount, billType);

        registry.registerBill(beneficiary, amount, billType);

        (uint256 id, address ben, uint256 amt, string memory bType, bool cleared, address clrBy) = registry.bills(1);
        
        assertEq(id, 1);
        assertEq(ben, beneficiary);
        assertEq(amt, amount);
        assertEq(bType, billType);
        assertFalse(cleared);
        assertEq(clrBy, address(0));
    }

    function test_ClearBill() public {
        uint256 amount = 1.5 ether;
        registry.registerBill(beneficiary, amount, "MORTGAGE");

        registry.setAuthorizedDonor(donor, true);

        uint256 beneficiaryBalanceBefore = beneficiary.balance;

        vm.prank(donor);
        vm.expectEmit(true, true, false, true);
        emit BillCleared(1, donor, amount);

        registry.clearBill{value: amount}(1);

        (,,, , bool cleared, address clrBy) = registry.bills(1);
        assertTrue(cleared);
        assertEq(clrBy, donor);
        assertEq(beneficiary.balance, beneficiaryBalanceBefore + amount);
    }

    function test_RevertWhen_UnauthorizedClearBill() public {
        registry.registerBill(beneficiary, 1 ether, "MEDICAL");

        vm.prank(address(0x999));
        vm.expectRevert();
        registry.clearBill{value: 1 ether}(1);
    }
}
