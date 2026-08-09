// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title AntiCorruptionWhistleblowerVault
 * @dev Anonymous corruption reporting with Zero-Knowledge Commitments & Bounty Escrow
 */
contract AntiCorruptionWhistleblowerVault {
    address public immutable owner;
    uint256 public reportCount;
    uint256 public constant REQUIRED_VERIFICATIONS = 3; // Kailangan ng 3 na "Citizen Auditors" para ma-validate

    struct Report {
        bytes32 evidenceHash;      // Hash ng ebidensya (PDF, photo, video na naka-store sa IPFS)
        bytes32 secretCommitment;  // Ginagamit ng reporter para i-claim ang bounty gamit ang secret key
        uint256 bountyAmount;
        uint256 approvalCount;
        bool isVerified;
        bool isClaimed;
        uint256 timestamp;
    }

    mapping(uint256 => Report) public reports;
    mapping(address => bool) public authorizedAuditors;
    mapping(uint256 => mapping(address => bool)) public auditorVotes;

    event ReportSubmitted(uint256 indexed id, bytes32 evidenceHash, uint256 timestamp);
    event ReportVerified(uint256 indexed id);
    event BountyClaimed(uint256 indexed id, address indexed recipient);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the Ghost");
        _;
    }

    modifier onlyAuditor() {
        require(authorizedAuditors[msg.sender], "Not a certified auditor");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    // Magdagdag ng trusted auditors (hal. mga pinagkakatiwalaang NGO leaders)
    function addAuditor(address _auditor) external onlyOwner {
        authorizedAuditors[_auditor] = true;
    }

    // Mag-submit ng anonymous report (walang sender address na naka-link sa report)
    function submitReport(bytes32 _evidenceHash, bytes32 _secretCommitment, uint256 _requestedBounty) external returns (uint256) {
        reportCount++;
        reports[reportCount] = Report({
            evidenceHash: _evidenceHash,
            secretCommitment: _secretCommitment,
            bountyAmount: _requestedBounty,
            approvalCount: 0,
            isVerified: false,
            isClaimed: false,
            timestamp: block.timestamp
        });
        emit ReportSubmitted(reportCount, _evidenceHash, block.timestamp);
        return reportCount;
    }

    // Ang mga auditors ay magve-verify ng report
    function verifyReport(uint256 _reportId) external onlyAuditor {
        Report storage report = reports[_reportId];
        require(!report.isVerified, "Already verified");
        require(!auditorVotes[_reportId][msg.sender], "Already voted");

        auditorVotes[_reportId][msg.sender] = true;
        report.approvalCount++;

        if (report.approvalCount >= REQUIRED_VERIFICATIONS) {
            report.isVerified = true;
            emit ReportVerified(_reportId);
        }
    }

    // I-claim ng whistleblower ang bounty gamit ang secret key (anonymously)
    function claimBounty(uint256 _reportId, bytes32 _secretKey) external {
        Report storage report = reports[_reportId];
        require(report.isVerified, "Report not yet verified");
        require(!report.isClaimed, "Bounty already claimed");

        // Patunayan na ang secret key ay tugma sa commitment
        bytes32 calculatedCommitment = keccak256(abi.encodePacked(_secretKey, msg.sender));
        require(calculatedCommitment == report.secretCommitment, "Invalid secret proof");

        report.isClaimed = true;
        payable(msg.sender).transfer(report.bountyAmount);
        emit BountyClaimed(_reportId, msg.sender);
    }
}
