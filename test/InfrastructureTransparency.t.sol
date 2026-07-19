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

        (string memory name, string memory location, InfrastructureTransparency.Status status, uint256 lastUpdate) =
            infra.projects(1);
        assertEq(name, "Flood Control Phase 1");
        assertEq(location, "Malolos");
        assertEq(uint256(status), uint256(InfrastructureTransparency.Status.Pending));
        assertGt(lastUpdate, 0);

        // ✅ second destructuring → use unique variable names
        (string memory name2, string memory location2, InfrastructureTransparency.Status status2, uint256 lastUpdate2) =
            infra.projects(1);
        assertEq(name2, "Flood Control Phase 1");
        assertEq(location2, "Malolos");
        assertEq(uint256(status2), uint256(InfrastructureTransparency.Status.Pending));
        assertGt(lastUpdate2, 0);
    }

    function testUpdateStatus() public {
        infra.submitProject("Drainage Upgrade", "Baliwag");
        infra.updateStatus(1, InfrastructureTransparency.Status.Ongoing);

        (,, InfrastructureTransparency.Status status1,) = infra.projects(1);
        assertEq(uint256(status1), uint256(InfrastructureTransparency.Status.Ongoing));

        // ✅ second destructuring → renamed variable
        (,, InfrastructureTransparency.Status status2,) = infra.projects(1);
        assertEq(uint256(status2), uint256(InfrastructureTransparency.Status.Ongoing));
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
