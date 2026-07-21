// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/MojangBedrockPolicyCodex.sol";

contract MojangBedrockPolicyCodexTest is Test {
    MojangBedrockPolicyCodex codex;

    function setUp() public {
        codex = new MojangBedrockPolicyCodex();
    }

    function testRegisterPolicySuccess() public {
        uint256 id = codex.registerPolicy("Gameplay", "Ensure fair resource distribution");
        MojangBedrockPolicyCodex.Policy memory policy = codex.getPolicy(id);

        assertEq(policy.id, id);
        assertEq(policy.domain, "Gameplay");
        assertEq(policy.requirement, "Ensure fair resource distribution");
        assertTrue(policy.enforced);
    }

    function testMultiplePoliciesIndependent() public {
        uint256 id1 = codex.registerPolicy("Identity", "Unique player identity enforcement");
        uint256 id2 = codex.registerPolicy("Security", "Prevent compromised mods");

        MojangBedrockPolicyCodex.Policy memory p1 = codex.getPolicy(id1);
        MojangBedrockPolicyCodex.Policy memory p2 = codex.getPolicy(id2);

        assertEq(p1.domain, "Identity");
        assertEq(p2.domain, "Security");
    }

    function testOnlyContractorCanRegister() public {
        vm.prank(address(0xBEEF));
        vm.expectRevert("Error: Only Sovereign Contractor access.");
        codex.registerPolicy("Fraudulent", "Invalid requirement");
    }
}
