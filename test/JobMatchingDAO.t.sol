// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/EducationCredential.sol";
import "../src/JobMatchingDAO.sol";

contract JobMatchingDAOTest is Test {
    EducationCredential public edu;
    JobMatchingDAO public jobDao;

    address public owner = address(this);
    address public employer = makeAddr("employer");
    address public applicant1 = makeAddr("applicant1");

    function setUp() public {
        edu = new EducationCredential();
        jobDao = new JobMatchingDAO(address(edu));

        // Issue a credential to applicant1 – this will be tokenId 0
        bytes32 hash = keccak256(abi.encodePacked("Solidity Engineer"));
        uint256 tokenId = edu.issueCredential(applicant1, "Solidity Engineering", "Tinkerer University", hash);
        
        // Sanity check: tokenId should be 0
        assertEq(tokenId, 0);
        // Verify the student actually owns the token
        assertEq(edu.ownerOf(tokenId), applicant1);
    }

    function test_JobLifecycle() public {
        // 1. Owner posts a job for the employer
        vm.prank(owner);
        uint256 jobId = jobDao.postJob(employer, "Solidity Engineer", "Build smart contracts", 10 ether);

        // 2. Applicant1 applies using their credential (tokenId 0)
        vm.prank(applicant1);
        jobDao.applyForJob(jobId, 0);

        JobMatchingDAO.Application[] memory apps = jobDao.getApplications(jobId);
        assertEq(apps.length, 1);
        assertEq(apps[0].applicant, applicant1);
        assertFalse(apps[0].isHired);

        // 3. Employer hires the applicant
        vm.prank(employer);
        jobDao.hireApplicant(jobId, applicant1);

        // 4. Verify job is filled
        JobMatchingDAO.Job memory job = jobDao.getJob(jobId);
        assertEq(job.employer, employer);
        assertEq(job.role, "Solidity Engineer");
        assertTrue(job.isFilled);
        assertEq(job.hiredApplicant, applicant1);
    }
}
