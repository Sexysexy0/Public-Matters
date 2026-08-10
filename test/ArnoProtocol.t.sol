// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/ArnoProtocol.sol";

contract ArnoProtocolTest is Test {
    ArnoProtocol arno;
    address sinner = address(0x9999);

    function setUp() public {
        arno = new ArnoProtocol();
    }

    function test_Redemption() public {
        arno.redemption(sinner, 50);
        assertEq(arno.collateral(sinner), 50);
    }

    function test_Forgive() public {
        arno.redemption(sinner, 100);
        arno.forgive(sinner);
        assertEq(arno.collateral(sinner), 0);
    }

    function test_RevertWhenNoCollateral() public {
        vm.expectRevert("No collateral staked");
        arno.forgive(sinner);
    }
}
