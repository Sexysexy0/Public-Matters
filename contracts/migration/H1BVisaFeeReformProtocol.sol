// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title H1BVisaFeeReformProtocol
/// @notice Registry for H-1B visa fee dignity, refund eligibility, and surcharge breach tagging
/// @dev Anchors flat fee enforcement and emotional consequence tagging for global talent corridors

contract H1BVisaFeeReformProtocol {
    address public steward;
    mapping(address => bool) public auditors;

    modifier onlySteward() {
        require(msg.sender == steward, "Not steward");
        _;
    }

    modifier onlyAuditor() {
        require(auditors[msg.sender] || msg.sender == steward, "Not auditor");
        _;
    }

    enum FeeStatus {
        Pending,
        Paid,
        Refunded,
        BreachFlagged
    }

    struct Applicant {
        string name;
        string nationality;
        string occupation;
        bool active;
        uint256 registeredAt;
    }

    struct VisaFee {
        uint256 id;
        address applicant;
        uint256 paidAmount;
        FeeStatus status;
        string employer;
        string emotionalTag;
        string notes;
        uint256 createdAt;
        uint256 updatedAt;
    }

    uint256 public nextFeeId = 1;
    mapping(address => Applicant) public applicantRegistry;
    mapping(uint256 => VisaFee) public feeRegistry;
    mapping(address => uint256[]) public applicantFeeIds;

    event AuditorSet(address indexed account, bool status);
    event ApplicantRegistered(address indexed applicant, string name, string nationality);
    event FeeFiled(uint256 indexed id, address indexed applicant, uint256 amount, string employer);
    event FeeStatusUpdated(uint256 indexed id, FeeStatus status, string emotionalTag);
    event RefundIssued(uint256 indexed id, address indexed applicant, uint256 amount);

    constructor() {
        steward = msg.sender;
        auditors[msg.sender] = true;
        emit AuditorSet(msg.sender, true);
    }

    function setAuditor(address account, bool status) external onlySteward {
        auditors[account] = status;
        emit AuditorSet(account, status);
    }

    function registerApplicant(address applicantAddr, string calldata name, string calldata nationality, string calldata occupation) external onlyAuditor {
        require(!applicantRegistry[applicantAddr].active, "Already registered");
        applicantRegistry[applicantAddr] = Applicant({
            name: name,
            nationality: nationality,
            occupation: occupation,
            active: true,
            registeredAt: block.timestamp
        });
        emit ApplicantRegistered(applicantAddr, name, nationality);
    }

    function fileVisaFee(
        address applicantAddr,
        uint256 amount,
        string calldata employer,
        string calldata notes
    ) external onlyAuditor returns (uint256 id) {
        require(applicantRegistry[applicantAddr].active, "Applicant not registered");
        id = nextFeeId++;
        feeRegistry[id] = VisaFee({
            id: id,
            applicant: applicantAddr,
            paidAmount: amount,
            status: FeeStatus.Pending,
            employer: employer,
            emotionalTag: "",
            notes: notes,
            createdAt: block.timestamp,
            updatedAt: block.timestamp
        });
        applicantFeeIds[applicantAddr].push(id);
        emit FeeFiled(id, applicantAddr, amount, employer);
    }

    function updateFeeStatus(uint256 id, FeeStatus status, string calldata emotionalTag) external onlyAuditor {
        VisaFee storage vf = feeRegistry[id];
        require(vf.id != 0, "Fee record not found");
        vf.status = status;
        vf.emotionalTag = emotionalTag;
        vf.updatedAt = block.timestamp;
        emit FeeStatusUpdated(id, status, emotionalTag);
        if (status == FeeStatus.Refunded) {
            emit RefundIssued(id, vf.applicant, vf.paidAmount);
        }
    }

    function getApplicant(address applicantAddr) external view returns (Applicant memory) {
        return applicantRegistry[applicantAddr];
    }

    function getVisaFee(uint256 id) external view returns (VisaFee memory) {
        return feeRegistry[id];
    }

    function listApplicantFees(address applicantAddr) external view returns (uint256[] memory) {
        return applicantFeeIds[applicantAddr];
    }
}
