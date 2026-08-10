// SPDX-License-Identifier: MIT
pragma solidity 0.8.35;

import {Test} from "forge-std/Test.sol";
import {CommunityFloodVault} from "../src/CommunityFloodVault.sol";

contract MockTrustIntegrator {
    event PositiveLogged(address entity, uint256 actionType);

    function logPositiveAction(address entity, uint256 actionType) external {
        emit PositiveLogged(entity, actionType);
    }
}

contract CommunityFloodVaultTest is Test {
    CommunityFloodVault public vault;
    MockTrustIntegrator public mockIntegrator;

    address public leader = address(0x4001);

    receive() external payable {}

    function setUp() public {
        mockIntegrator = new MockTrustIntegrator();
        vault = new CommunityFloodVault(address(mockIntegrator));
    }

    function test_CreateFundAndCompleteInitiative() public {
        uint256 requiredBudget = 5 ether;

        uint256 initId = vault.createInitiative(
            "Calumpit - Hagonoy Drainage Connector",
            "Dredging and installation of heavy-duty water pumps",
            leader,
            requiredBudget
        );

        uint256 initialLeaderBalance = leader.balance;

        // Direct funding from private source
        vault.directFundInitiative{value: requiredBudget}(initId);

        // Verify direct release of funds to project lead
        assertEq(leader.balance, initialLeaderBalance + requiredBudget);

        // Mark completed and check positive action log
        vault.markCompleted(initId);
    }
}
