// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/OperatorPrivileges.sol";
import "../src/SecurityIncidentResponseRegistryV2.sol";

contract SecurityIncidentResponseRegistryV2Test is Test {
    OperatorPrivileges privileges;
    SecurityIncidentResponseRegistryV2 registry;
    address op = vm.addr(1);

    function setUp() public {
        privileges = new OperatorPrivileges();
        registry = new SecurityIncidentResponseRegistryV2(address(privileges));
        privileges.addOperator(op);
    }

    function testReportAndResolve() public {
        bytes32 id = keccak256("sega-hack");
        vm.prank(op);
        registry.reportIncident(id, keccak256("allnet"), keccak256("critical"));

        vm.prank(op);
        registry.updateStatus(id, SecurityIncidentResponseRegistryV2.IncidentStatus.RESOLVED);

        (,,, SecurityIncidentResponseRegistryV2.IncidentStatus status,,, ) = registry.incidents(id);
        assertEq(uint8(status), uint8(SecurityIncidentResponseRegistryV2.IncidentStatus.RESOLVED));
    }
}
