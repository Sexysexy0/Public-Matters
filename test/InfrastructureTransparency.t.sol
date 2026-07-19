// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../contracts/InfrastructureTransparency.sol";

contract InfrastructureTransparencyTest is Test {
    InfrastructureTransparency infra;

    function setUp() public {
        infra = new InfrastructureTransparency();
    }

    function testSubmitProject() public {
        infra.submitProject("Flood Control Phase 1", "Malolos");
        (string memory name, string memory location, InfrastructureTransparency.Status status, uint256 lastUpdate) = infra.projects(1);
        assertEq(name, "Flood Control Phase 1");
        assertEq(location, "Malolos");
        assertEq(uint(status), uint(InfrastructureTransparency.Status.Pending));
        (string memory name, string memory location, InfrastructureTransparency.Status status, uint256 lastUpdate) =
            infra.projects(1);
        assertEq(name, "Flood Control Phase 1");
        assertEq(location, "Malolos");
        assertEq(uint256(status), uint256(InfrastructureTransparency.Status.Pending));
        assertGt(lastUpdate, 0);
    }

    function testUpdateStatus() public {
        infra.submitProject("Drainage Upgrade", "Baliwag");
        infra.updateStatus(1, InfrastructureTransparency.Status.Ongoing);
        (, , InfrastructureTransparency.Status status, ) = infra.projects(1);
        assertEq(uint(status), uint(InfrastructureTransparency.Status.Ongoing));
        (,, InfrastructureTransparency.Status status,) = infra.projects(1);
        assertEq(uint256(status), uint256(InfrastructureTransparency.Status.Ongoing));
    }

    function testUrgentActionFlag() public {
        infra.submitProject("Road Repair", "San Jose del Monte");
        infra.updateStatus(1, InfrastructureTransparency.Status.Delayed);
        bool urgent = infra.needsUrgentAction(1);
        assertTrue(urgent);
    }

    function testGovernanceTransfer() public {
        address newGov = address(0xBEEF);
        infra.transferGovernance(newGov);
        assertEq(infra.governanceBody(), newGov);
    }
}
