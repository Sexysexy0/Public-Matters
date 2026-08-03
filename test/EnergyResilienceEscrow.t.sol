// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/EnergyResilienceEscrow.sol";

contract EnergyResilienceEscrowTest is Test {
    EnergyResilienceEscrow public ere;

    address public admin = address(this);
    address public operator = address(0x1);

    uint256 public initialThreshold = 100; // $100/barrel benchmark

    function setUp() public {
        // Deploy contract with 10 ETH buffer reserve
        ere = new EnergyResilienceEscrow{value: 10 ether}(initialThreshold);
        ere.registerOperator(operator);
    }

    function test_TriggerAndClaimSubsidy() public {
        address[] memory operators = new address[](1);
        operators[0] = operator;

        uint256[] memory amounts = new uint256[](1);
        amounts[0] = 2 ether;

        // Oil price spikes to $110/barrel (> threshold of 100)
        ere.triggerEmergencySubsidy(operators, amounts, 110);

        assertEq(ere.operatorAllocations(operator), 2 ether);

        // Operator claims subsidy
        uint256 preBalance = operator.balance;
        vm.prank(operator);
        ere.claimSubsidy();

        assertEq(operator.balance - preBalance, 2 ether);
        assertEq(ere.operatorAllocations(operator), 0);
    }

    receive() external payable {}
}
