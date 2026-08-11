// SPDX-License-Identifier: MIT
pragma solidity 0.8.35;

import "forge-std/Test.sol";
import "../src/FairPriceBudgetVault.sol";

contract FairPriceBudgetVaultTest is Test {
    FairPriceBudgetVault vault;
    address steward = address(this);

    // Kailangan ito para makatanggap ang test contract ng ETH mula sa vault withdrawal
    receive() external payable {}

    function setUp() public {
        vault = new FairPriceBudgetVault(1000);
    }

    function test_InitialReductionCalculation() public view {
        assertEq(vault.baselineBudget(), 1000);
        assertEq(vault.targetReducedBudget(), 500);
    }

    function test_AutomatedSafetyBufferDeposit() public {
        vault.depositFunds{value: 1000}();

        assertEq(vault.emergencyReserve(), 150);
        assertEq(vault.totalAllocatedFunds(), 850);
    }

    function test_CategoryCapEnforcement() public {
        vault.setCategoryCap("Bilihin", 300);
        vault.logExpense("Bilihin", 200, "Unang bili");

        vm.expectRevert("Expense exceeds defined category cap limit");
        vault.logExpense("Bilihin", 150, "Lalagpas sa cap");
    }

    function test_EmergencyWithdrawal() public {
        vault.depositFunds{value: 1000}();
        assertEq(vault.emergencyReserve(), 150);

        vault.withdrawEmergencyReserve(50);
        assertEq(vault.emergencyReserve(), 100);
    }
}
