// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

/**
 * @title JobMatchingDAO
 * @dev Transparent job market matching employers with verified credential holders.
 */
contract JobMatchingDAO {
    address public immutable owner;
    address public educationCredentialContract; // Address of the EducationCredential NFT

    struct Job {
        address employer;
        string role;
        string description;
        uint256 salary;
        bool isFilled;
        address hiredApplicant;
    }

    struct Application {
        address applicant;
        uint256 educationTokenId; // The NFT proof they own
        bool isHired;
    }

    uint256 public jobCounter;
    mapping(uint256 => Job) public jobs;
    mapping(uint256 => Application[]) public applications; // jobId => array of applications
    mapping(address => uint256[]) public employerJobIds;

    event JobPosted(uint256 indexed id, address employer, string role, uint256 salary);
    event ApplicationSubmitted(uint256 indexed jobId, address applicant, uint256 educationTokenId);
    event JobFilled(uint256 indexed jobId, address hiredApplicant);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the Ghost Architect");
        _;
    }

    constructor(address _educationCredentialContract) {
        owner = msg.sender;
        educationCredentialContract = _educationCredentialContract;
    }

    // Post a new job (only the architect can post on behalf of employers for now)
    function postJob(address _employer, string memory _role, string memory _description, uint256 _salary) external onlyOwner returns (uint256) {
        require(_employer != address(0), "Invalid employer");
        require(bytes(_role).length > 0, "Role required");
        require(_salary > 0, "Salary must be > 0");

        jobCounter++;
        jobs[jobCounter] = Job({
            employer: _employer,
            role: _role,
            description: _description,
            salary: _salary,
            isFilled: false,
            hiredApplicant: address(0)
        });
        employerJobIds[_employer].push(jobCounter);
        emit JobPosted(jobCounter, _employer, _role, _salary);
        return jobCounter;
    }

    // Apply for a job using an EducationCredential NFT as proof
    function applyForJob(uint256 _jobId, uint256 _educationTokenId) external {
        Job storage job = jobs[_jobId];
        require(job.employer != address(0), "Job does not exist");
        require(!job.isFilled, "Job is already filled");
        require(IERC721(educationCredentialContract).ownerOf(_educationTokenId) == msg.sender, "You do not own this credential");

        applications[_jobId].push(Application({
            applicant: msg.sender,
            educationTokenId: _educationTokenId,
            isHired: false
        }));
        emit ApplicationSubmitted(_jobId, msg.sender, _educationTokenId);
    }

    // Hire an applicant (called by the employer or owner)
    function hireApplicant(uint256 _jobId, address _applicant) external {
        Job storage job = jobs[_jobId];
        require(job.employer != address(0), "Job does not exist");
        require(!job.isFilled, "Job is already filled");
        require(msg.sender == job.employer || msg.sender == owner, "Not authorized to hire");

        // Find the application and mark them as hired
        bool found = false;
        for (uint256 i = 0; i < applications[_jobId].length; i++) {
            if (applications[_jobId][i].applicant == _applicant) {
                applications[_jobId][i].isHired = true;
                found = true;
                break;
            }
        }
        require(found, "Applicant has not applied");

        job.isFilled = true;
        job.hiredApplicant = _applicant;
        emit JobFilled(_jobId, _applicant);
    }

    // Get basic job info
    function getJob(uint256 _jobId) external view returns (Job memory) {
        return jobs[_jobId];
    }

    // Get all applications for a job
    function getApplications(uint256 _jobId) external view returns (Application[] memory) {
        return applications[_jobId];
    }
}
