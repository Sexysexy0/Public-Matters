// SPDX-License-Identifier: MIT
pragma solidity ^0.8.35;

import "forge-std/Test.sol";
import "../contracts/TimelockBuffer.sol";

contract TimelockBufferTest is Test {
    TimelockBuffer public buffer;
    address public operator = address(0x123);
    address public target = address(0x456);

    function setUp() public {
        buffer = new TimelockBuffer(operator);
    }

    function test_ExtendTimelock() public {
        vm.prank(operator);
        bytes32 actionId = buffer.proposeAction(target, "0x");

        // Get initial executeAfter time
        (,, uint256 initialExecuteAfter,,) = buffer.pendingActions(actionId);

        // Extend timelock by 3 days
        vm.prank(operator);
        buffer.extendTimelock(actionId, 3 days, "Requiring deeper audit");

        (,, uint256 newExecuteAfter,,) = buffer.pendingActions(actionId);
        assertEq(newExecuteAfter, initialExecuteAfter + 3 days);
    }

    function test_RevertWhen_ExtensionExceedsMax() public {
        vm.prank(operator);
        bytes32 actionId = buffer.proposeAction(target, "0x");

        vm.prank(operator);
        vm.expectRevert("TimelockBuffer: Extension exceeds max limit");
        buffer.extendTimelock(actionId, 15 days, "Exceeds max limit");
    }
}
