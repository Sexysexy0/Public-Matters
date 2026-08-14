// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/GovernanceBundle.sol";
import "../src/TransparencyMandateRegistry.sol";

contract GovernanceBundleTest is Test {
    GovernanceBundle bundle;
    TransparencyMandateRegistry registry;
    address supremeSteward = address(this);

    function setUp() public {
        registry = new TransparencyMandateRegistry();
        bundle = new GovernanceBundle(address(registry), supremeSteward);
    }

    function testDeployAndLinkCovenant() public {
        bytes32 id = keccak256("BillOfHumanPreservation");
        address covenant = bundle.deployAndLinkCovenant(
            id, "Bill of Human Preservation Covenant", "Humanity first, Living things next, System last"
        );
        TransparencyMandateRegistry.Project memory project = registry.getProject(id);
        assertEq(project.contractAddress, covenant);
        assertEq(project.category, "HumanPreservation");
    }

    function testEmergencyOverridePausesSystemAndRedistributes() public {
        address beneficiary1 = address(0x1111);
        address beneficiary2 = address(0x2222);
        address[] memory beneficiaries = new address[](2);
        beneficiaries[0] = beneficiary1;
        beneficiaries[1] = beneficiary2;

        uint256[] memory amounts = new uint256[](2);
        amounts[0] = 1 ether;
        amounts[1] = 2 ether;

        // Fund contract with reserves
        vm.deal(address(bundle), 3 ether);

        vm.expectEmit(true, true, true, true);
        emit GovernanceBundle.SystemPaused(true);

        vm.expectEmit(true, true, true, true);
        emit GovernanceBundle.ReserveRedistributed(beneficiary1, 1 ether);

        vm.expectEmit(true, true, true, true);
        emit GovernanceBundle.ReserveRedistributed(beneficiary2, 2 ether);

        vm.expectEmit(true, true, true, true);
        emit GovernanceBundle.EmergencyOverrideTriggered("Systemic collapse", block.timestamp);

        bundle.emergencyOverride("Systemic collapse", beneficiaries, amounts);

        assertTrue(bundle.systemPaused(), "System should be paused");
    }

    function testResumeSystem() public {
        bundle.resumeSystem();
        assertFalse(bundle.systemPaused(), "System should be resumed");
    }

    function testOnlySupremeStewardCanOverride() public {
        vm.prank(address(0x9999));
        vm.expectRevert("Not authorized");
        bundle.emergencyOverride("Unauthorized attempt", new address[](0), new uint256[](0));
    }
}
