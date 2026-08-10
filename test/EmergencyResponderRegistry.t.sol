// SPDX-License-Identifier: MIT
pragma solidity 0.8.35;

import {Test} from "forge-std/Test.sol";
import {EmergencyResponderRegistry} from "../src/EmergencyResponderRegistry.sol";

contract MockTrustIntegrator {
    event PositiveLogged(address entity, uint256 actionType);

    function logPositiveAction(address entity, uint256 actionType) external {
        emit PositiveLogged(entity, actionType);
    }
}

contract EmergencyResponderRegistryTest is Test {
    EmergencyResponderRegistry public registry;
    MockTrustIntegrator public mockIntegrator;

    address public leader = address(0x3001);

    receive() external payable {}

    function setUp() public {
        mockIntegrator = new MockTrustIntegrator();
        registry = new EmergencyResponderRegistry(address(mockIntegrator));
    }

    function test_RegisterFundAndVerifyRescue() public {
        uint256 unitId = registry.registerRescueUnit("Malolos Water Rescue Team 1", leader);
        uint256 dispatchBudget = 1 ether;

        uint256 initialBalance = leader.balance;

        // Fund and Dispatch
        registry.fundAndDispatchUnit{value: dispatchBudget}(unitId, "Evacuation at Hagonoy River Bank");
        assertEq(leader.balance, initialBalance + dispatchBudget);

        // Verify Completion & Trust Logging
        registry.verifyRescueCompletion(unitId);
    }
}
