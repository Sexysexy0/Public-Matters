// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/OperatorPrivileges.sol";
import "../src/OperatorConsciousnessLedger.sol";

contract BatchSafeguardTest is Test {
    OperatorPrivileges privileges;
    OperatorConsciousnessLedger ledger;
    address[] operators;

    function setUp() public {
        privileges = new OperatorPrivileges();
        ledger = new OperatorConsciousnessLedger(address(privileges));

        // Create 5 deterministic EOAs and authorize them
        for (uint256 i = 1; i <= 5; i++) {
            address op = vm.addr(i);
            operators.push(op);
            privileges.addOperator(op);
        }

        // Authorize ledger contract
        privileges.addOperator(address(ledger));
    }

    function testBatchSafeguardPreventsConcurrentActions() public {
        string memory action = "CriticalBatchAction";
        uint256 targetBlock = block.number + 5;

        // Roll to target block
        vm.roll(targetBlock);

        // Compute safeguard IDs for operators 0 and 1
        bytes32 id0 = keccak256(abi.encodePacked(operators[0], action, targetBlock));
        bytes32 id1 = keccak256(abi.encodePacked(operators[1], action, targetBlock));

        // Trigger safeguards for operators 0 and 1
        vm.prank(operators[0]);
        privileges.triggerSafeguard(id0, operators[0]);

        vm.prank(operators[1]);
        privileges.triggerSafeguard(id1, operators[1]);

        assertTrue(privileges.isSafeguarded(id0), "Operator 0 should be safeguarded");
        assertTrue(privileges.isSafeguarded(id1), "Operator 1 should be safeguarded");

        // Verify that safeguarded operators are blocked
        vm.prank(operators[0]);
        vm.expectRevert("Safeguard active");
        ledger.recordAction(action, 10);

        vm.prank(operators[1]);
        vm.expectRevert("Safeguard active");
        ledger.recordAction(action, 10);

        // Verify that non-safeguarded operators (2, 3, 4) succeed
        for (uint256 i = 2; i < operators.length; i++) {
            vm.prank(operators[i]);
            ledger.recordAction(action, 10);
        }

        // Verify final log count (only non-safeguarded operators succeeded)
        assertEq(ledger.getLogCount(), 3, "Ledger should record exactly 3 successful actions");
    }
}
