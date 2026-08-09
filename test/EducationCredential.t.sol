// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/EducationCredential.sol";

contract EducationCredentialTest is Test {
    EducationCredential public edu;

    address public owner = address(this);
    address public student = makeAddr("student");
    address public employer = makeAddr("employer");

    function setUp() public {
        edu = new EducationCredential();
    }

    function test_IssueAndVerify() public {
        bytes32 hash = keccak256(abi.encodePacked("Grades: A+"));
        uint256 tokenId = edu.issueCredential(student, "Solidity Engineering", "Tinkerer University", hash);

        (address studentAddr, uint256 gradDate, string memory course, string memory inst, bytes32 transcriptHash, bool isValid) = edu.getCredential(tokenId);

        assertEq(studentAddr, student);
        assertEq(course, "Solidity Engineering");
        assertEq(inst, "Tinkerer University");
        assertEq(transcriptHash, hash);
        assertTrue(isValid);

        // Verify that the student owns the NFT
        assertEq(edu.ownerOf(tokenId), student);
    }

    function test_RevokeCredential() public {
        uint256 tokenId = edu.issueCredential(student, "Blockchain 101", "Tinkerer University", bytes32(0));
        edu.revokeCredential(tokenId);

        (, , , , , bool isValid) = edu.getCredential(tokenId);
        assertFalse(isValid);
    }
}
