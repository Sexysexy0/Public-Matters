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

        (
            bytes32 _id,
            ITServiceRequestRegistry.TicketType _tType,
            ITServiceRequestRegistry.TicketStatus status,
            address _requester,
            address _assignedTo,
            bytes32 _detailsHash,
            bytes32 _resolutionHash,
            uint256 _createdAt,
            uint256 resolvedAt
        ) = registry.tickets(ticketId);
        assertEq(uint(status), uint(ITServiceRequestRegistry.TicketStatus.RESOLVED));
        assertGt(resolvedAt, 0);
    }
}
