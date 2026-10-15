// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/SovereigntyPolicyRegistry.sol";

contract SovereigntyPolicyRegistryTest is Test {
    SovereigntyPolicyRegistry registry;
    address governor = address(this);
    address unauthorized = address(0x123);

    function setUp() public {
        registry = new SovereigntyPolicyRegistry();
    }

    function testRegisterAndVerifyPolicy() public {
        bytes32 policyId = keccak256("POLICY_01");
        string memory title = "Border Control and Immigration Reform";
        string memory uri = "ipfs://bafybeig...";

        registry.registerPolicy(policyId, title, uri);

        (bool active, string memory retrievedTitle, string memory retrievedUri) = registry.verifyPolicy(policyId);
        assertTrue(active);
        assertEq(retrievedTitle, title);
        assertEq(retrievedUri, uri);
    }

    function test_RevertWhen_UnauthorizedRegister() public {
        bytes32 policyId = keccak256("POLICY_02");
        vm.prank(unauthorized);
        vm.expectRevert("Unauthorized: Only governor");
        registry.registerPolicy(policyId, "Unauthorized Policy", "ipfs://test");
    }

    function testRevokePolicy() public {
        bytes32 policyId = keccak256("POLICY_03");
        registry.registerPolicy(policyId, "Energy Master Plan", "ipfs://test");

        registry.revokePolicy(policyId);
        (bool active,,) = registry.verifyPolicy(policyId);
        assertFalse(active);
    }
}
