// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./IAuditHistory.sol";

contract HolisticCompetencyRegistry {
    address public sovereignContractor;
    IAuditHistory public auditHistory;
    
    uint256 public totalEngineers;

    struct EngineerNode {
        address nodeAddress;
        bool hasVerifiableCPD;
        bool characterReferralVerified;
        uint256 lastValidationTimestamp;
        bool isCompetencyValidated;
    }

    mapping(address => EngineerNode) public engineers;

    event CompetencyRegistered(address indexed engineer, bool status);
    event CompetencyRevoked(address indexed engineer);

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

    function registerProfessionalEngineer(
        address _engineer,
        bool _cpdStatus,
        bool _referralStatus
    ) public onlyContractor {
        require(_engineer != address(0), "Error: Invalid node pointer.");
        
        bool finalValidation = (_cpdStatus && _referralStatus);
        
        engineers[_engineer] = EngineerNode({
            nodeAddress: _engineer,
            hasVerifiableCPD: _cpdStatus,
            characterReferralVerified: _referralStatus,
            lastValidationTimestamp: block.timestamp,
            isCompetencyValidated: finalValidation
        });

        totalEngineers++;
        emit CompetencyRegistered(_engineer, finalValidation);

        if (address(auditHistory) != address(0)) {
            try auditHistory.logHistoricalAction(_engineer, 0, finalValidation ? 1 : 0, finalValidation ? 0 : 1, "VICTORIAN_ACT_COMPETENCY_SETTLED") {} catch {}
        }
    }

    function checkAndRevokeNonCompliantNode(address _engineer) public returns (bool) {
        EngineerNode storage e = engineers[_engineer];
        if (e.isCompetencyValidated && (!e.hasVerifiableCPD || !e.characterReferralVerified)) {
            e.isCompetencyValidated = false;
            emit CompetencyRevoked(_engineer);
            return true;
        }
        return !e.isCompetencyValidated;
    }
}
