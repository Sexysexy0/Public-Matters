// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// AITrainingOrchestrator: link content, consents, audits, and compliance checks
contract AITrainingOrchestrator {
    address public steward;

    address public contentLedger;
    address public consentRegistry;
    address public auditMirror;
    address public complianceGuard;

    event AccountabilityEvaluated(
        string dataset,
        uint256 contentId,
        uint256 consentId,
        uint256 auditId,
        uint256 complianceId,
        string classification
    );

    constructor(
        address _contentLedger,
        address _consentRegistry,
        address _auditMirror,
        address _complianceGuard
    ) {
        steward = msg.sender;
        contentLedger = _contentLedger;
        consentRegistry = _consentRegistry;
        auditMirror = _auditMirror;
        complianceGuard = _complianceGuard;
    }

    function updateContractAddresses(
        address _contentLedger,
        address _consentRegistry,
        address _auditMirror,
        address _complianceGuard
    ) external {
        require(msg.sender == steward, "Only steward");
        contentLedger = _contentLedger;
        consentRegistry = _consentRegistry;
        auditMirror = _auditMirror;
        complianceGuard = _complianceGuard;
    }

    // Evaluate accountability by linking IDs from each ledger
    function evaluateAccountability(
        string calldata dataset,
        uint256 contentId,
        uint256 consentId,
        uint256 auditId,
        uint256 complianceId
    ) external {
        require(msg.sender == steward, "Only steward");

        string memory classification;
        if (complianceId > 0) {
            classification = "Compliant";
        } else if (auditId > 0) {
            classification = "Audit Pending";
        } else if (consentId > 0) {
            classification = "Consent Recorded";
        } else if (contentId > 0) {
            classification = "Content Logged";
        } else {
            classification = "No Record";
        }

        emit AccountabilityEvaluated(dataset, contentId, consentId, auditId, complianceId, classification);
    }
}
