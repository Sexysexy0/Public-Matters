// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "forge-std/Test.sol";
import "../src/OperatorPrivileges.sol";
import "../src/ITServiceRequestRegistry.sol";

contract ITServiceRequestRegistryTest is Test {
    OperatorPrivileges privileges;
    ITServiceRequestRegistry registry;
    address op = vm.addr(1);
    address user = vm.addr(2);

    function setUp() public {
        privileges = new OperatorPrivileges();
        privileges.addOperator(op);
        registry = new ITServiceRequestRegistry(address(privileges));
    }

    function testFullTicketLifecycle() public {
        vm.prank(user);
        bytes32 ticketId = registry.createTicket(ITServiceRequestRegistry.TicketType.INCIDENT, keccak256("Server Down"));

        vm.prank(op);
        registry.assignTicket(ticketId, op);

        vm.prank(op);
        registry.resolveTicket(ticketId, keccak256("Restarted Server"));

        (,, ITServiceRequestRegistry.TicketStatus status,,,,,, uint256 resolvedAt) = registry.tickets(ticketId);
        assertEq(uint256(status), uint256(ITServiceRequestRegistry.TicketStatus.RESOLVED));
        assertGt(resolvedAt, 0);
    }
}
