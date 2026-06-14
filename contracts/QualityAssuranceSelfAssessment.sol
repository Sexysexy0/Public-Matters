// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./IAuditHistory.sol";

contract QualityAssuranceSelfAssessment {
    address public sovereignContractor;
    IAuditHistory public auditHistory;
    
    uint256 public totalSARAudits;

    struct SARRecord {
        uint256 id;
        address evaluationBranch;
        string departmentName;
        bytes32 evidenceDataHash;
        uint256 submissionTimestamp;
        bool isApproved;
    }

    mapping(uint256 => SARRecord) public audits;
    mapping(address => bool) public complianceBannedBranches;

    event SARSubmitted(uint256 indexed sarId, address indexed branch, bytes32 evidenceHash);
    event SARComplianceValidated(uint256 indexed sarId, bool status);

    modifier onlyContractor() {
        require(msg.sender == sovereignContractor, "Error: Only Sovereign Contractor access.");
        _;
    }

    constructor() {
        sovereignContractor = msg.sender;
    }

    function setAuditHistoryAddress(address _auditHistoryAddress) public onlyContractor {
        auditHistory = IAuditHistory(_auditHistoryAddress);
    }

    function submitSelfAssessmentReport(
        string memory _deptName,
        bytes32 _evidenceHash
    ) public returns (uint256) {
        require(!complianceBannedBranches[msg.sender], "Error: Branch node is banned due to previous nonconformity.");
        require(_evidenceHash != bytes32(0), "Error: Invalid empty evidence tracking hash.");

        totalSARAudits++;
        audits[totalSARAudits] = SARRecord({
            id: totalSARAudits,
            evaluationBranch: msg.sender,
            departmentName: _deptName,
            evidenceDataHash: _evidenceHash,
            submissionTimestamp: block.timestamp,
            isApproved: false
        });

        emit SARSubmitted(totalSARAudits, msg.sender, _evidenceHash);
        return totalSARAudits;
    }

    function evaluateSARCompliance(uint256 _sarId, bool _status) public onlyContractor {
        SARRecord storage s = audits[_sarId];
        require(s.id != 0, "Error: Target SAR entry does not exist.");
        
        s.isApproved = _status;
        if (!_status) {
            complianceBannedBranches[s.evaluationBranch] = true;
        }

        emit SARComplianceValidated(_sarId, _status);

        if (address(auditHistory) != address(0)) {
            try auditHistory.logHistoricalAction(s.evaluationBranch, 0, _status ? 1 : 0, _status ? 0 : 1, "SAR_EVALUATION_SETTLED") {} catch {}
        }
    }
}
