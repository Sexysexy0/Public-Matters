// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/ZeroKnowledgeIdentityAttestation.sol";

contract ZeroKnowledgeIdentityAttestationTest is Test {
    ZeroKnowledgeIdentityAttestation public zkia;

    address public admin = address(this);
    address public user = address(0x1);

    bytes32 public identityCommitment = keccak256(abi.encodePacked("UserSecretIdentity123"));
    bytes32 public claimHash = keccak256(abi.encodePacked("Over21YearsOldClaim"));

    function setUp() public {
        zkia = new ZeroKnowledgeIdentityAttestation();
        
        // Admin registers identity attestation for user
        zkia.registerAttestation(user, identityCommitment, 95);
    }

    function test_RegisterAttestationSuccess() public {
        (bytes32 commitment, uint256 trustScore, , bool isVerified) = zkia.attestations(user);
        assertEq(commitment, identityCommitment);
        assertEq(trustScore, 95);
        assertTrue(isVerified);
    }

    function test_ProveSelectiveAttributeSuccess() public {
        // Generate expected proof signature
        bytes32 proofSignature = keccak256(abi.encodePacked(user, claimHash, identityCommitment));

        // User proves attribute without revealing underlying raw identity
        vm.prank(user);
        zkia.proveSelectiveAttribute(claimHash, proofSignature);

        assertTrue(zkia.provenClaims(user, claimHash));
    }
}
