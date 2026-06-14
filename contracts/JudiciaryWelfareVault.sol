// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./IAuditHistory.sol";

/**
 * @title JudiciaryWelfareVault
 * @dev Nagpapatupad ng isang pinag-isang Healthcare at Welfare Plan para sa buong network,
 * inspirasyon sa pormal na pagpapatupad ng Comprehensive Healthcare Plan ng Korte Suprema (Hulyo 2024).
 * Pinapamahalaan nito ang minimal personal contributions at dynamic claims disbursement paths.
 */
contract JudiciaryWelfareVault {
    address public guardian;
    IAuditHistory public auditHistory;
    uint256 public totalClaims;

    struct WelfareClaim {
        uint256 id;
        address employee;
        uint256 requestedAmount;
        bytes32 medicalDiagnosticHash; // Cryptographic footprint ng medical record/billing
        bool isApproved;
        bool isSettled;
    }

    // Rate ng minimal personal contribution para sa lock hydration (e.g., 0.01 ether)
    uint256 public mandatoryContribution;
    
    mapping(uint256 => WelfareClaim) public claims;
    mapping(address => uint256) public memberContributions;
    mapping(address => bool) public activeCoverage;

    event ContributionReceived(address indexed member, uint256 amount);
    event ClaimFiled(uint256 indexed claimId, address indexed employee, uint256 amount);
    event ClaimSettled(uint256 indexed claimId, address indexed employee, uint256 amount);
    event CoverageStatusUpdated(address indexed member, bool status);

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Error: Access denied. Only the Sovereign Guardian can route welfare funds.");
        _;
    }

    constructor(uint256 _mandatoryContribution) {
        guardian = msg.sender;
        mandatoryContribution = _mandatoryContribution;
    }

    function setAuditHistoryAddress(address _auditHistoryAddress) public onlyGuardian {
        auditHistory = IAuditHistory(_auditHistoryAddress);
    }

    /**
     * @dev Hakbang 1: Pagbabayad ng minimal personal contribution para i-activate ang comprehensive health coverage.
     */
    function depositContribution() public payable {
        require(msg.value >= mandatoryContribution, "Error: Contribution amount below the mandatory minimal tier.");
        
        memberContributions[msg.sender] += msg.value;
        activeCoverage[msg.sender] = true;

        emit ContributionReceived(msg.sender, msg.value);
        emit CoverageStatusUpdated(msg.sender, true);
    }

    /**
     * @dev Hakbang 2: Pagsusumite ng claim ng isang empleyado ng Judiciary para sa medical medical reimbursement.
     */
    function fileWelfareClaim(uint256 _requestedAmount, bytes32 _diagnosticHash) public returns (uint256) {
        require(activeCoverage[msg.sender], "Error: Inactive coverage. Minimal personal contribution required.");
        require(_requestedAmount > 0, "Error: Claim allocation amount must be greater than zero.");

        totalClaims++;
        claims[totalClaims] = WelfareClaim({
            id: totalClaims,
            employee: msg.sender,
            requestedAmount: _requestedAmount,
            medicalDiagnosticHash: _diagnosticHash,
            isApproved: false,
            isSettled: false
        });

        emit ClaimFiled(totalClaims, msg.sender, _requestedAmount);
        return totalClaims;
    }

    /**
     * @dev Hakbang 3: Pormal na pag-approve at pag-settle ng claim ng Guardian mula sa centralized liquidity pool.
     * Awtomatikong nagpapadala ng telemetry log (+1 grant record) sa central InstitutionalAuditHistory ledger.
     */
    function settleWelfareClaim(uint256 _claimId) public onlyGuardian {
        require(_claimId > 0 && _claimId <= totalClaims, "Error: Welfare claim context non-existent.");
        WelfareClaim storage c = claims[_claimId];
        require(!c.isSettled, "Error: Claim has already been settled and closed.");
        require(address(this).balance >= c.requestedAmount, "Error: Insufficient vault pool liquidity reserves.");

        c.isApproved = true;
        c.isSettled = true;

        address targetEmployee = c.employee;
        uint256 amount = c.requestedAmount;

        payable(targetEmployee).transfer(amount);
        emit ClaimSettled(_claimId, targetEmployee, amount);

        // CROSS-CONTRACT TELEMETRY AUTOMATION: Itatala ang etikal na pondo bilang +1 grant sa kasaysayan ng sub-node
        if (address(auditHistory) != address(0)) {
            try auditHistory.logHistoricalAction(targetEmployee, 0, 1, 0, "HEALTHCARE_CLAIM_DISBURSED") {} catch {}
        }
    }

    // Pondo para sa seeding ng public medical liquidity pool
    receive() external payable {}
}
