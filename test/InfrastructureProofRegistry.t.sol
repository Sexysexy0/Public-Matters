// SPDX-License-Identifier: MIT
pragma solidity 0.8.35;

import {Test} from "forge-std/Test.sol";
import {InfrastructureProofRegistry} from "../src/InfrastructureProofRegistry.sol";

contract MockTrustIntegrator {
    event PositiveLogged(address entity, uint256 actionType);
    event SetbackLogged(address entity, uint256 setbackType);

    function logPositiveAction(address entity, uint256 actionType) external {
        emit PositiveLogged(entity, actionType);
    }

    function logSetback(address entity, uint256 setbackType) external {
        emit SetbackLogged(entity, setbackType);
    }
}

contract InfrastructureProofRegistryTest is Test {
    InfrastructureProofRegistry public registry;
    MockTrustIntegrator public mockIntegrator;

    address public owner = address(this);
    address public contractor = address(0x2001);
    uint256 public constant LICENSE_CATEGORY = 1 << 0; // Category Bitmask

    receive() external payable {}

    function setUp() public {
        mockIntegrator = new MockTrustIntegrator();
        registry = new InfrastructureProofRegistry(address(mockIntegrator));
        registry.registerContractorLicense(contractor, LICENSE_CATEGORY);
    }

    function test_RegisterProjectAndApproveMilestone() public {
        uint256 budget = 2 ether;
        uint256 milestones = 2;

        uint256 projectId = registry.registerProject{value: budget}(
            "Flood Mitigation Dike - Calumpit",
            contractor,
            milestones,
            LICENSE_CATEGORY
        );

        uint256 initialBalance = contractor.balance;

        // Approve 1st Milestone
        registry.approveMilestone(projectId);
        assertEq(contractor.balance, initialBalance + 1 ether);

        // Approve 2nd Milestone (Completes Project)
        registry.approveMilestone(projectId);
        assertEq(contractor.balance, initialBalance + 2 ether);
    }

    function test_ReportAuditFailure() public {
        uint256 budget = 1 ether;
        uint256 projectId = registry.registerProject{value: budget}(
            "Ghost Project Test",
            contractor,
            1,
            LICENSE_CATEGORY
        );

        registry.reportAuditFailure(projectId);
    }
}
