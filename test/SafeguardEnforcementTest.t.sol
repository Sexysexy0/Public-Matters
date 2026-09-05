// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/OperatorPrivileges.sol";
import "../src/OperatorConsciousnessLedger.sol";

contract SafeguardEnforcementTest is Test {
    OperatorPrivileges privileges;
    OperatorConsciousnessLedger ledger;

    address operator1;
    address operator2;

    function setUp() public {
        privileges = new OperatorPrivileges();
        ledger = new OperatorConsciousnessLedger(address(privileges));

        operator1 = vm.addr(1);
        operator2 = vm.addr(2);

        // Authorize operators and ledger contract
        privileges.addOperator(operator1);
        privileges.addOperator(operator2);
        privileges.addOperator(address(ledger));
    }

    function testSafeguardAllowsAuthorizedOperator() public {
        vm.prank(operator1);
        ledger.recordAction("Normal Action", 10);
        assertEq(ledger.getLogCount(), 1);
    }

    function testSafeguardBlocksAction() public {
        string memory action = "Dangerous Action";

        // Target a specific future block to keep the safeguardId deterministic
        uint256 targetBlock = block.number + 1;
        vm.roll(targetBlock);

        // Compute the exact safeguardId for operator1, action, and targetBlock
        bytes32 safeguardId = keccak256(abi.encodePacked(operator1, action, targetBlock));

        // Trigger the safeguard
        vm.prank(operator1);
        privileges.triggerSafeguard(safeguardId, operator1);

        // Verify that the safeguard is active
        assertTrue(privileges.isSafeguarded(safeguardId), "Safeguard should be active");

        // Attempting to record the action should now revert as expected
        vm.prank(operator1);
        vm.expectRevert("Safeguard active");
        ledger.recordAction(action, 10);
    }
}
