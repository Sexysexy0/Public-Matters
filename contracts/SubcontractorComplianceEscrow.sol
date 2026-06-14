// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./IAuditHistory.sol";

/**
 * @title SubcontractorComplianceEscrow
 * @dev Nagpapatupad ng City of Atlanta Office of Contract Compliance Audit standards.
 * Pinapatawan ng strict 3-day constraint freeze ang mga non-compliant primes.
 */
contract SubcontractorComplianceEscrow {
    address public sovereignContractor;
    IAuditHistory public auditHistory;
    
    uint256 public constant PAYMENT_PROOF_WINDOW = 3 days;
    uint256 public totalProjects;

    struct ProjectTier {
        uint256 id;
        address primeContractor;
        address subcontractor;
        uint256 allocatedSubFunds;
        uint256 lastFundingReleasedTimestamp;
        bool hasPendingProof;
        bytes32 activePaymentHashProof;
    }

    mapping(uint256 => ProjectTier) public projects;
    mapping(address => bool) public complianceBannedPrimes;

    event ProjectInitiated(uint256 indexed projectId, address indexed prime, address indexed sub, uint256 subAllocation);
    event FundingReleasedToPrime(uint256 indexed projectId, uint256 amountReleased);
    event PaymentProofUploaded(uint256 indexed projectId, bytes32 indexed proofHash);
    event PrimeComplianceSanctioned(address indexed primeContractor, bool status);

    modifier onlyContractor() {
        require(msg.sender == sovereignContractor, "Error: Access denied. Only the Sovereign Contractor holds execution access.");
        _;
    }

    modifier onlyActivePrime(uint256 _projectId) {
        require(projects[_projectId].primeContractor == msg.sender, "Error: Unauthorized. Node is not the assigned Prime Contractor.");
        require(!complianceBannedPrimes[msg.sender], "Error: Prime Contractor node is locked due to unresolved compliance nonconformity.");
        _;
    }

    constructor() {
        sovereignContractor = msg.sender;
    }

    function setAuditHistoryAddress(address _auditHistoryAddress) public onlyContractor {
        auditHistory = IAuditHistory(_auditHistoryAddress);
    }

    function initiateProjectPlan(
        address _prime,
        address _sub
    ) public onlyContractor returns (uint256) {
        require(_prime != address(0) && _sub != address(0), "Error: Invalid organizational node address.");
        
        totalProjects++;
        projects[totalProjects] = ProjectTier({
            id: totalProjects,
            primeContractor: _prime,
            subcontractor: _sub,
            allocatedSubFunds: 0,
            lastFundingReleasedTimestamp: 0,
            hasPendingProof: false,
            activePaymentHashProof: bytes32(0)
        });

        emit ProjectInitiated(totalProjects, _prime, _sub, 0);
        return totalProjects;
    }

    /**
     * @dev Pormal na evaluation mechanism upang maglapat ng compliance sanctions bago mag-revert ang draw workflows.
     */
    function checkAndSanctionOverduePrime(uint256 _projectId) public returns (bool) {
        ProjectTier storage p = projects[_projectId];
        if (p.hasPendingProof && (block.timestamp > p.lastFundingReleasedTimestamp + PAYMENT_PROOF_WINDOW)) {
            complianceBannedPrimes[p.primeContractor] = true;
            emit PrimeComplianceSanctioned(p.primeContractor, true);
            
            if (address(auditHistory) != address(0)) {
                try auditHistory.logHistoricalAction(p.primeContractor, 0, 0, 1, "SUBCONTRACTOR_PAYMENT_OVERDUE") {} catch {}
            }
            return true;
        }
        return complianceBannedPrimes[p.primeContractor];
    }

    /**
     * @dev Pagpapalabas ng funding draw draw gamit ang active tracking constraints loops.
     */
    function releaseProjectFundingDraw(uint256 _projectId) public payable onlyContractor {
        ProjectTier storage p = projects[_projectId];
        require(p.id != 0, "Error: Project plan does not exist in master contracts record.");
        
        // I-trigger ang check; kung may violation, mag-apply ng permanent state ban bago mag-revert
        checkAndSanctionOverduePrime(_projectId);

        require(!complianceBannedPrimes[p.primeContractor], "Error: Funding draw rejected. Prime Contractor violated the strict 3-day proof of payment upload rule.");
        require(msg.value > 0, "Error: Funding release draw must be greater than zero.");

        uint256 subShare = msg.value / 2;
        uint256 primeShare = msg.value - subShare;

        p.allocatedSubFunds += subShare;
        p.lastFundingReleasedTimestamp = block.timestamp;
        p.hasPendingProof = true;

        (bool success, ) = p.primeContractor.call{value: primeShare}("");
        require(success, "Error: Transfer allocation to Prime Contractor node failed.");

        emit FundingReleasedToPrime(_projectId, msg.value);
    }

    function uploadSubcontractorPaymentProof(
        uint256 _projectId, 
        bytes32 _proofHash
    ) public onlyActivePrime(_projectId) {
        ProjectTier storage p = projects[_projectId];
        require(p.hasPendingProof, "Error: System identified no pending subcontractor payment compliance checks for this draw.");
        require(block.timestamp <= p.lastFundingReleasedTimestamp + PAYMENT_PROOF_WINDOW, "Error: Upload window closed. 3-day business constraint broken.");

        p.hasPendingProof = false;
        p.activePaymentHashProof = _proofHash;

        uint256 payoutToSub = p.allocatedSubFunds;
        p.allocatedSubFunds = 0;

        (bool success, ) = p.subcontractor.call{value: payoutToSub}("");
        require(success, "Error: Transfer allocation to Subcontractor node failed.");

        emit PaymentProofUploaded(_projectId, _proofHash);

        if (address(auditHistory) != address(0)) {
            try auditHistory.logHistoricalAction(p.subcontractor, 0, 1, 0, _proofHash) {} catch {}
        }
    }
}
