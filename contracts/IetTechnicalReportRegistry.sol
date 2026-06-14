// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./IAuditHistory.sol";

/**
 * @title IetTechnicalReportRegistry
 * @dev Hango sa IET Technical Report Writing guidelines at UIC SE template.
 * Nagpapatupad ng strict structural verification para sa design controls documentation.
 */
contract IetTechnicalReportRegistry {
    address public sovereignContractor;
    IAuditHistory public auditHistory;

    struct TechnicalReport {
        uint256 reportId;
        address authorNode;
        bytes32 requirementsRootHash;
        uint256 versionIndex;
        bool hasVerifiableReferences;
        bool isStructureApproved;
    }

    mapping(uint256 => TechnicalReport) public reports;
    uint256 public totalReports;

    event ReportRegistered(uint256 indexed id, address indexed author, bytes32 requirementsRoot);
    event ReportStructureRejected(uint256 indexed id, address indexed author);

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

    /**
     * @dev IET TECHNICAL STYLE INVARIANT FRAMEWORK: Sapilitang nirereject at nire-revert 
     * ng system ang structural block submission kung walang verifiable references 
     * o walang bitbit na valid software engineering requirements metadata verification hash.
     */
    function registerTechnicalDocumentation(
        address _author,
        bytes32 _requirementsHash,
        uint256 _version,
        bool _hasReferences
    ) public onlyContractor returns (uint256) {
        require(_requirementsHash != bytes32(0), "Error: Missing requirements tracking hash.");
        require(_hasReferences, "Error: Structural violation. Technical reports must include references.");

        totalReports++;
        
        reports[totalReports] = TechnicalReport({
            reportId: totalReports,
            authorNode: _author,
            requirementsRootHash: _requirementsHash,
            versionIndex: _version,
            hasVerifiableReferences: _hasReferences,
            isStructureApproved: true
        });

        emit ReportRegistered(totalReports, _author, _requirementsHash);

        if (address(auditHistory) != address(0)) {
            try auditHistory.logHistoricalAction(_author, 0, 1, 0, _requirementsHash) {} catch {}
        }

        return totalReports;
    }
}
