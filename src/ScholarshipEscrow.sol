// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title ScholarshipEscrow
 * @dev Manages milestone-based scholarship fund distributions with multi-stakeholder verification.
 */
contract ScholarshipEscrow {
    enum MilestoneStatus {
        Pending,
        Approved,
        Disbursed
    }

    struct Student {
        bytes32 studentId;
        address payable studentAddress;
        uint256 totalGrantAmount;
        uint256 amountDisbursed;
        bool isActive;
    }

    struct Milestone {
        uint256 milestoneId;
        uint256 amount;
        bytes32 proofHash; // Hash of grades, attendance, or enrollment doc
        MilestoneStatus status;
    }

    address public admin;
    address public verifier; // School / Auditor address

    mapping(bytes32 => Student) public students;
    mapping(bytes32 => Milestone[]) public studentMilestones;

    event StudentEnrolled(bytes32 indexed studentId, address indexed studentAddress, uint256 grantAmount);
    event MilestoneAdded(bytes32 indexed studentId, uint256 indexed milestoneId, uint256 amount);
    event MilestoneApproved(bytes32 indexed studentId, uint256 indexed milestoneId);
    event FundsDisbursed(bytes32 indexed studentId, uint256 indexed milestoneId, uint256 amount);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Unauthorized: Admin only");
        _;
    }

    modifier onlyVerifier() {
        require(msg.sender == verifier || msg.sender == admin, "Unauthorized: Verifier only");
        _;
    }

    constructor(address _verifier) payable {
        admin = msg.sender;
        verifier = _verifier;
    }

    receive() external payable {}

    function enrollStudent(bytes32 _rawId, address payable _studentAddress, uint256 _totalGrant)
        external
        onlyAdmin
        returns (bytes32)
    {
        bytes32 studentId = keccak256(abi.encodePacked(_rawId, _studentAddress));
        require(!students[studentId].isActive, "Student already enrolled");

        students[studentId] = Student({
            studentId: studentId,
            studentAddress: _studentAddress,
            totalGrantAmount: _totalGrant,
            amountDisbursed: 0,
            isActive: true
        });

        emit StudentEnrolled(studentId, _studentAddress, _totalGrant);
        return studentId;
    }

    function addMilestone(bytes32 _studentId, uint256 _amount, bytes32 _proofHash) external onlyAdmin {
        require(students[_studentId].isActive, "Student not found");

        uint256 currentTotal = students[_studentId].amountDisbursed;
        Milestone[] storage milestones = studentMilestones[_studentId];

        for (uint256 i = 0; i < milestones.length; i++) {
            currentTotal += milestones[i].amount;
        }
        require(currentTotal + _amount <= students[_studentId].totalGrantAmount, "Exceeds total grant");

        uint256 mId = milestones.length;
        milestones.push(
            Milestone({milestoneId: mId, amount: _amount, proofHash: _proofHash, status: MilestoneStatus.Pending})
        );

        emit MilestoneAdded(_studentId, mId, _amount);
    }

    function approveMilestone(bytes32 _studentId, uint256 _milestoneId) external onlyVerifier {
        Milestone storage m = studentMilestones[_studentId][_milestoneId];
        require(m.status == MilestoneStatus.Pending, "Milestone not pending");

        m.status = MilestoneStatus.Approved;
        emit MilestoneApproved(_studentId, _milestoneId);
    }

    function disburseMilestone(bytes32 _studentId, uint256 _milestoneId) external {
        Student storage student = students[_studentId];
        Milestone storage m = studentMilestones[_studentId][_milestoneId];

        require(student.isActive, "Student inactive");
        require(m.status == MilestoneStatus.Approved, "Milestone not approved");
        require(address(this).balance >= m.amount, "Insufficient vault balance");

        m.status = MilestoneStatus.Disbursed;
        student.amountDisbursed += m.amount;

        (bool success,) = student.studentAddress.call{value: m.amount}("");
        require(success, "Transfer failed");

        emit FundsDisbursed(_studentId, _milestoneId, m.amount);
    }
}
