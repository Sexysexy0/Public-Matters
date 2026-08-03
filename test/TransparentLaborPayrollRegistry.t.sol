// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/TransparentLaborPayrollRegistry.sol";

contract TransparentLaborPayrollRegistryTest is Test {
    TransparentLaborPayrollRegistry public tlpr;

    address public admin = address(this);
    address public worker = makeAddr("worker");

    function setUp() public {
        // Deploy with 10 ETH in payroll reserve escrow
        tlpr = new TransparentLaborPayrollRegistry{value: 10 ether}();
        tlpr.registerWorker(worker, "EMP-2026-001", 1 ether); // 1 ETH daily rate benchmark
    }

    function test_ProcessAndDisbursePayroll() public {
        uint256 cycleId = 1;
        uint256 daysWorked = 5; // 5 days
        uint256 deductions = 0.5 ether; // statutory deductions
        uint256 expectedNetPay = 4.5 ether; // (5 * 1) - 0.5

        // Admin processes payroll
        tlpr.processPayroll(worker, cycleId, daysWorked, deductions);

        uint256 preBalance = worker.balance;

        // Admin disburses payment directly to worker wallet
        tlpr.disbursePayroll(worker, cycleId);

        assertEq(worker.balance - preBalance, expectedNetPay);

        (, , , , bool isDisbursed) = tlpr.workerPayrollHistory(worker, cycleId);
        assertTrue(isDisbursed);
    }
}
