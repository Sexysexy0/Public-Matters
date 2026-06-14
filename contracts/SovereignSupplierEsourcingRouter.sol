// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./IAuditHistory.sol";

/**
 * @title SovereignSupplierEsourcingRouter
 * @dev Hango sa Sovereign Network Group (SNG) Supplier Handbook at Baker McKenzie CCPA Compliance.
 * Nagpapatupad ng strict onboarding requirements, AML registry checks, at 24-hour breach lockdowns.
 */
contract SovereignSupplierEsourcingRouter {
    address public sovereignContractor;
    IAuditHistory public auditHistory;

    struct SupplierRegistry {
        uint256 supplierId;
        address companyNode;
        bytes32 amlClearanceProofHash;
        uint256 lastValidationTimestamp;
        bool hasActiveSourcingClearance;
        bool privacyBreachLock;
    }

    mapping(address => SupplierRegistry) public suppliers;
    uint256 public totalSuppliers;

    event SupplierOnboarded(address indexed supplier, bytes32 amlHash);
    event PrivacySanctionTriggered(address indexed supplier, string reasonCode);
    event SecurityAuditLogged(address indexed supplier, bytes32 trackingHash);

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

    function registerSngSupplier(
        address _company,
        bytes32 _amlHash
    ) public onlyContractor returns (uint256) {
        require(_company != address(0), "Error: Invalid supplier node identifier.");
        require(_amlHash != bytes32(0), "Error: SNG InTend Framework requirement. Missing AML validation hash.");

        totalSuppliers++;
        suppliers[_company] = SupplierRegistry({
            supplierId: totalSuppliers,
            companyNode: _company,
            amlClearanceProofHash: _amlHash,
            lastValidationTimestamp: block.timestamp,
            hasActiveSourcingClearance: true,
            privacyBreachLock: false
        });

        emit SupplierOnboarded(_company, _amlHash);
        return totalSuppliers;
    }

    /**
     * @dev SNG PO DATA PRIVACY PROTECTION MATRIX: Alinsunod sa SNG Clause at CCPA 24-hour 
     * breach reporting rules, kapag ang isang supplier node ay nakitaan ng unlawful processing 
     * o Personal Data Breach, awtomatikong isasara ang access nito sa active vendor pool.
     */
    function enforcePrivacyBreachSanction(
        address _company,
        bytes32 _incidentSecurityLogHash
    ) public onlyContractor {
        SupplierRegistry storage s = suppliers[_company];
        require(s.hasActiveSourcingClearance, "Error: Target supplier profile is currently inactive.");

        s.hasActiveSourcingClearance = false;
        s.privacyBreachLock = true;

        emit PrivacySanctionTriggered(_company, "SNG_CCPA_BREACH_DETECTED");
        emit SecurityAuditLogged(_company, _incidentSecurityLogHash);

        if (address(auditHistory) != address(0)) {
            try auditHistory.logHistoricalAction(_company, 0, 0, 1, "SNG_PRIVACY_BREACH_LOCKDOWN") {} catch {}
        }
    }
}
