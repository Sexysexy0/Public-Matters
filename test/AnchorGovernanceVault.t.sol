// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/AnchorGovernanceVault.sol";

contract AnchorGovernanceVaultTest is Test {
    AnchorGovernanceVault public anchor;

    address public owner = address(this);
    address public random = makeAddr("random");

    function setUp() public {
        anchor = new AnchorGovernanceVault();
    }

    function test_SetCoreContractsAndPause() public {
        address r = makeAddr("registry");
        address v = makeAddr("vault");
        address t = makeAddr("treaty");
        address e = makeAddr("escrow");
        address a = makeAddr("arbitration");

        anchor.setCoreContracts(r, v, t, e, a);

        (address _registry, address _vault, address _treaty, address _escrow, address _arbitration, bool _paused) = anchor.getSystemStatus();

        assertEq(_registry, r);
        assertEq(_vault, v);
        assertEq(_treaty, t);
        assertEq(_escrow, e);
        assertEq(_arbitration, a);
        assertFalse(_paused);

        anchor.pause();
        (, , , , , _paused) = anchor.getSystemStatus();
        assertTrue(_paused);
    }

    function test_RevertWhenNonOwnerCalls() public {
        vm.prank(random);
        vm.expectRevert("Only the owner");
        anchor.pause();
    }
}
