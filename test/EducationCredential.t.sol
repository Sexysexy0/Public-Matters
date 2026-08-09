// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/EducationCredential.sol";

contract MockTrustIntegrator {
    uint256 public lastWeight;
    function logPositiveAction(uint256 _weight) external {
        lastWeight = _weight;
    }
}

contract EducationCredentialTest is Test {
    EducationCredential public edu;
    MockTrustIntegrator public mockIntegrator;

    address public owner = address(this);
    address public student = makeAddr("student");

    function setUp() public {
        mockIntegrator = new MockTrustIntegrator();
        edu = new EducationCredential(address(mockIntegrator));
    }

    function test_IssueAndVerify_UpdatesTrust() public {
        bytes32 hash = keccak256(abi.encodePacked("Grades: A+"));
        uint256 tokenId = edu.issueCredential(student, "Solidity Engineering", "Tinkerer University", hash);

        (address studentAddr, uint256 gradDate, string memory course, string memory inst, bytes32 transcriptHash, bool isValid) = edu.getCredential(tokenId);
        assertEq(studentAddr, student);
        assertEq(course, "Solidity Engineering");
        assertEq(inst, "Tinkerer University");
        assertEq(transcriptHash, hash);
        assertTrue(isValid);
        assertEq(edu.ownerOf(tokenId), student);

        // Verify the Trust Integrator was called with weight 10
        assertEq(mockIntegrator.lastWeight(), 10);
    }

    function test_RevokeCredential() public {
        uint256 tokenId = edu.issueCredential(student, "Blockchain 101", "Tinkerer University", bytes32(0));
        edu.revokeCredential(tokenId);

        (, , , , , bool isValid) = edu.getCredential(tokenId);
        assertFalse(isValid);
    }
}
