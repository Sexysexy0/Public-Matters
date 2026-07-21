// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/WorkforceValuePolicyCodex.sol";

contract WorkforceValuePolicyCodexTest is Test {
    WorkforceValuePolicyCodex codex;

    function setUp() public {
        codex = new WorkforceValuePolicyCodex();
    }

    function testRegisterPolicySuccess() public {
        uint256 id = codex.registerPolicy("Practical", "Job must solve economic stability");
        WorkforceValuePolicyCodex.Policy memory policy = codex.getPolicy(id);

        assertEq(policy.id, id);
        assertEq(policy.dimension, "Practical");
        assertEq(policy.requirement, "Job must solve economic stability");
        assertTrue(policy.enforced);
    }

    function testMultiplePoliciesIndependent() public {
        uint256 id1 = codex.registerPolicy("Emotional", "Job must provide sense of purpose");
        uint256 id2 = codex.registerPolicy("Social", "Job must enhance perception of competence");

        WorkforceValuePolicyCodex.Policy memory p1 = codex.getPolicy(id1);
        WorkforceValuePolicyCodex.Policy memory p2 = codex.getPolicy(id2);

        assertEq(p1.dimension, "Emotional");
        assertEq(p2.dimension, "Social");
    }

    function testOnlyContractorCanRegister() public {
        vm.prank(address(0xBEEF));
        vm.expectRevert("Error: Only Sovereign Contractor access.");
        codex.registerPolicy("Fraudulent", "Invalid requirement");
    }
}
