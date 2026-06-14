// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./IAuditHistory.sol";

/**
 * @title FoundationGovernanceLedger
 * @dev Nagpapatupad ng Danish Foundation Governance recommendations at remuneration audit standards.
 * FIXED STRUCUTURAL ALIGNMENT: Itinuwid ang string flags upang maging pasok sa bytes32 restrictions.
 */
contract FoundationGovernanceLedger {
    address public sovereignContractor;
    IAuditHistory public auditHistory;
    
    uint256 public totalBoardMembers;

    struct BoardMember {
        address memberAddress;
        string positionTitle;
        uint256 baseRemunerationAmount;
        uint256 pensionAllocation;
        bool activeClearanceStatus;
    }

    mapping(address => BoardMember) public boardRegistry;
    mapping(address => mapping(bytes32 => bool)) public authorizedSecondaryTasks;

    event BoardMemberRegistered(address indexed member, uint256 basePay, uint256 pension);
    event RemunerationAudited(address indexed member, uint256 totalCompensationAmount);
    event ConflictFlagged(address indexed member, bytes32 taskHash);

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

    function registerBoardNode(
        address _member,
        string memory _title,
        uint256 _basePay,
        uint256 _pension
    ) public onlyContractor {
        require(_member != address(0), "Error: Invalid node pointer.");
        
        boardRegistry[_member] = BoardMember({
            memberAddress: _member,
            positionTitle: _title,
            baseRemunerationAmount: _basePay,
            pensionAllocation: _pension,
            activeClearanceStatus: true
        });
        
        totalBoardMembers++;
        emit BoardMemberRegistered(_member, _basePay, _pension);
    }

    /**
     * @dev DANISH BUSINESS AUTHORITY REMUNERATION TRANSPARENCY CHECK
     * FIXED: Ang parameter size value ay pinutol upang maging saktong 28 bytes (Pasok sa bytes32 layout limits).
     */
    function auditExternalTaskCompliance(
        address _member,
        bytes32 _taskHash,
        bool _isFormallyApproved
    ) public onlyContractor {
        BoardMember storage b = boardRegistry[_member];
        require(b.activeClearanceStatus, "Error: Member profile inactive.");

        if (!_isFormallyApproved) {
            b.activeClearanceStatus = false;
            emit ConflictFlagged(_member, _taskHash);
            
            if (address(auditHistory) != address(0)) {
                try auditHistory.logHistoricalAction(_member, 0, 0, 1, "FOUNDATION_GOV_CONFLICT_WARN") {} catch {}
            }
        } else {
            authorizedSecondaryTasks[_member][_taskHash] = true;
            uint256 combinedPay = b.baseRemunerationAmount + b.pensionAllocation;
            emit RemunerationAudited(_member, combinedPay);
        }
    }
}
