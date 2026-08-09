// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/EducationCredential.sol";
import "../src/JobMatchingDAO.sol";

contract MockTrustIntegrator {
    function logPositiveAction(uint256) external {}
}

contract JobMatchingDAOTest is Test {
    EducationCredential public edu;
    JobMatchingDAO public jobDao;

    address public owner = address(this);
    address public employer = makeAddr("employer");
    address public applicant1 = makeAddr("applicant1");

    function setUp() public {
        MockTrustIntegrator mock = new MockTrustIntegrator();
        edu = new EducationCredential(address(mock));
        jobDao = new JobMatchingDAO(address(edu));

        bytes32 hash = keccak256(abi.encodePacked("Solidity Engineer"));
        edu.issueCredential(applicant1, "Solidity Engineering", "Tinkerer University", hash);
    }

    function test_JobLifecycle() public {
        vm.prank(owner);
        uint256 jobId = jobDao.postJob(employer, "Solidity Engineer", "Build smart contracts", 10 ether);

        vm.prank(applicant1);
        jobDao.applyForJob(jobId, 0);

        JobMatchingDAO.Application[] memory apps = jobDao.getApplications(jobId);
        assertEq(apps.length, 1);
        assertEq(apps[0].applicant, applicant1);
        assertFalse(apps[0].isHired);

        vm.prank(employer);
        jobDao.hireApplicant(jobId, applicant1);

        JobMatchingDAO.Job memory job = jobDao.getJob(jobId);
        assertEq(job.employer, employer);
        assertEq(job.role, "Solidity Engineer");
        assertTrue(job.isFilled);
        assertEq(job.hiredApplicant, applicant1);
    }
}
