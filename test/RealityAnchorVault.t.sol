// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/RealityAnchorVault.sol";

contract RealityAnchorVaultTest is Test {
    RealityAnchorVault vault;
    address debtor = address(0x2);

    function setUp() public {
        vault = new RealityAnchorVault();
    }

    function test_AssignAndPayLiability() public {
        // Master assigns liability
        vault.assignLiability(debtor, 1 ether);
        assertEq(vault.outstandingLiabilities(debtor), 1 ether);

        // Debtor must pay in full
        vm.deal(debtor, 2 ether);
        vm.prank(debtor);
        vault.payInFull{value: 1 ether}();
        
        // Liability should be zeroed out
        assertEq(vault.outstandingLiabilities(debtor), 0);
    }
}
