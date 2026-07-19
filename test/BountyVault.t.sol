// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/BountyVault.sol";

contract BountyVaultTest is Test {
    BountyVault vault;
    address owner;
    address recipient = address(0xFEE1);

    function setUp() public {
        owner = address(this);
        vault = new BountyVault();
        // fund the vault via createBounty payable
    }

    function testCreateAndPayBounty() public {
        uint256 initial = address(recipient).balance;
        // create bounty by sending value
        uint256 id = vault.createBounty{value: 0.1 ether}();
        // pay bounty (owner only)
        vault.payBounty(id, payable(recipient));
        assertEq(address(recipient).balance, initial + 0.1 ether);
    }

    function testCannotPayTwice() public {
        uint256 id = vault.createBounty{value: 0.05 ether}();
        vault.payBounty(id, payable(recipient));
        vm.expectRevert();
        vault.payBounty(id, payable(recipient));
    }
}
