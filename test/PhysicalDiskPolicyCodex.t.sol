// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/PhysicalDiskPolicyCodex.sol";

contract PhysicalDiskPolicyCodexTest is Test {
    PhysicalDiskPolicyCodex codex;

    function setUp() public {
        codex = new PhysicalDiskPolicyCodex();
    }

    function testRegisterPolicySuccess() public {
        uint256 id = codex.registerPolicy("Preservation", "All games must have physical disk availability");
        PhysicalDiskPolicyCodex.Policy memory policy = codex.getPolicy(id);

        assertEq(policy.id, id);
        assertEq(policy.domain, "Preservation");
        assertEq(policy.requirement, "All games must have physical disk availability");
        assertTrue(policy.enforced);
    }

    function testMultiplePoliciesIndependent() public {
        uint256 id1 = codex.registerPolicy("Accessibility", "Disks ensure offline access");
        uint256 id2 = codex.registerPolicy("Ownership", "Disks provide tangible proof of purchase");

        PhysicalDiskPolicyCodex.Policy memory p1 = codex.getPolicy(id1);
        PhysicalDiskPolicyCodex.Policy memory p2 = codex.getPolicy(id2);

        assertEq(p1.domain, "Accessibility");
        assertEq(p2.domain, "Ownership");
    }

    function testOnlyContractorCanRegister() public {
        vm.prank(address(0xBEEF));
        vm.expectRevert("Error: Only Sovereign Contractor access.");
        codex.registerPolicy("Fraudulent", "Invalid requirement");
    }
}
