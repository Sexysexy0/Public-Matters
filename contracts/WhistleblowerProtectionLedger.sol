// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title WhistleblowerProtectionLedger
 * @dev Anonymous Corruption Reporting, Zero-Knowledge Verification & Bounty Escrow
 */
contract WhistleblowerProtectionLedger {
    address public rootAdmin;
    uint256 public reportCount;

    struct Report {
        bytes32 evidenceHash;      // IPFS/Cryptographic hash of encrypted evidence
        bytes32 secretCommitment;  // Commitment hash to verify whistleblower burner payout wallet
        uint256 bountyAmount;
        uint256 approvalCount;
        bool isVerified;
        bool isClaimed;
    }

    mapping(uint256 => Report) public reports;
    mapping(address => bool) public authorizedAuditors;
    mapping(uint256 => mapping(address => bool)) public auditorVotes;

    uint256 public constant REQUIRED_AUDIT_APPROVALS = 2;

    event AuditorRegistered(address indexed auditor);
    event ReportSubmitted(uint256 indexed reportId, bytes32 evidenceHash);
    event ReportVerified(uint256 indexed reportId);
    event BountyClaimed(uint256 indexed reportId, address indexed recipient);

    modifier onlyAdmin() {
        require(msg.sender == rootAdmin, "WPL: Only Root Admin authorized");
        _;
    }

    modifier onlyAuditor() {
        require(authorizedAuditors[msg.sender], "WPL: Only authorized auditors allowed");
        _;
    }

    constructor() payable {
        rootAdmin = msg.sender;
    }

    receive() external payable {}

    function registerAuditor(address _auditor) external onlyAdmin {
        authorizedAuditors[_auditor] = true;
        emit AuditorRegistered(_auditor);
    }

    function submitReport(
        bytes32 _evidenceHash,
        bytes32 _secretCommitment,
        uint256 _requestedBounty
    ) external returns (uint256) {
        require(_requestedBounty <= address(this).balance, "WPL: Insufficient escrow bounty pool");

        reportCount++;
        reports[reportCount] = Report({
            evidenceHash: _evidenceHash,
            secretCommitment: _secretCommitment,
            bountyAmount: _requestedBounty,
            approvalCount: 0,
            isVerified: false,
            isClaimed: false
        });

        emit ReportSubmitted(reportCount, _evidenceHash);
        return reportCount;
    }

    function verifyReport(uint256 _reportId) external onlyAuditor {
        Report storage report = reports[_reportId];
        require(!report.isVerified, "WPL: Report already verified");
        require(!auditorVotes[_reportId][msg.sender], "WPL: Auditor already voted");

        auditorVotes[_reportId][msg.sender] = true;
        report.approvalCount++;

        if (report.approvalCount >= REQUIRED_AUDIT_APPROVALS) {
            report.isVerified = true;
            emit ReportVerified(_reportId);
        }
    }

    function claimBounty(uint256 _reportId, bytes32 _secretKey) external {
        Report storage report = reports[_reportId];
        require(report.isVerified, "WPL: Report not yet verified");
        require(!report.isClaimed, "WPL: Bounty already claimed");

        // Verify that the secret key matches the whistleblower's commitment
        bytes32 calculatedCommitment = keccak256(abi.encodePacked(_secretKey, msg.sender));
        require(calculatedCommitment == report.secretCommitment, "WPL: Invalid secret proof");

        report.isClaimed = true;

        (bool success, ) = payable(msg.sender).call{value: report.bountyAmount}("");
        require(success, "WPL: Bounty transfer failed");

        emit BountyClaimed(_reportId, msg.sender);
    }
}
