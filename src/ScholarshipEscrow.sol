// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title ScholarshipEscrow
 * @dev Auto‑disburses scholarships from its own balance.
 */
contract ScholarshipEscrow {
    address public immutable owner;

    struct Scholarship {
        address student;
        uint256 amount;
        uint256 semester;
        bool claimed;
    }

    mapping(address => Scholarship[]) public scholarships;
    mapping(address => bool) public accreditedSchools;

    event ScholarshipGranted(address indexed student, uint256 amount, uint256 semester);
    event ScholarshipClaimed(address indexed student, uint256 amount, uint256 semester);
    event SchoolAccredited(address indexed school);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the architect");
        _;
    }

    modifier onlyAccredited() {
        require(accreditedSchools[msg.sender], "Not an accredited school");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    receive() external payable {}

    // Deposit funds (anyone can fund, but usually Endowment or owner)
    function deposit() external payable {
        require(msg.value > 0, "Must deposit some funds");
    }

    // Accredit a school (only owner)
    function accreditSchool(address _school) external onlyOwner {
        require(!accreditedSchools[_school], "Already accredited");
        accreditedSchools[_school] = true;
        emit SchoolAccredited(_school);
    }

    // Grant a scholarship (only accredited school)
    function grantScholarship(address _student, uint256 _amount, uint256 _semester) external onlyAccredited {
        require(_student != address(0), "Invalid student");
        require(_amount > 0, "Amount must be > 0");

        scholarships[_student].push(
            Scholarship({student: _student, amount: _amount, semester: _semester, claimed: false})
        );

        emit ScholarshipGranted(_student, _amount, _semester);
    }

    // Claim a scholarship (student calls this)
    function claimScholarship(uint256 _index) external {
        Scholarship storage s = scholarships[msg.sender][_index];
        require(s.student != address(0), "Scholarship does not exist");
        require(!s.claimed, "Already claimed");
        require(address(this).balance >= s.amount, "Insufficient balance");

        s.claimed = true;
        payable(msg.sender).transfer(s.amount);
        emit ScholarshipClaimed(msg.sender, s.amount, s.semester);
    }

    // Get all scholarships for a student
    function getScholarships(address _student) external view returns (Scholarship[] memory) {
        return scholarships[_student];
    }
}
