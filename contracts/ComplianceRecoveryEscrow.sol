// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./IAuditHistory.sol";

contract ComplianceRecoveryEscrow {
    address public guardian;
    address public publicBenefitVault;
    IAuditHistory public auditHistory;
    uint256 public totalCases;

    struct RecoveryCase {
        address institution;
        uint256 collateralAmount;
        string requiredImprovement;
        uint256 expirationTime;
        bool isResolved;
    }

    mapping(uint256 => RecoveryCase) public cases;

    event RecoveryInitiated(uint256 indexed caseId, address indexed institution, uint256 amount);
    event RecoveryApproved(uint256 indexed caseId, uint256 amount);
    event CollateralForfeited(uint256 indexed caseId, address indexed institution, uint256 amount);
    event AuditHistoryAddressUpdated(address indexed newAddress);

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Error: Access denied. Only the Guardian can execute recovery routing.");
        _;
    }

    constructor(address _publicBenefitVault) {
        guardian = msg.sender;
        publicBenefitVault = _publicBenefitVault;
    }

    function setAuditHistoryAddress(address _auditHistoryAddress) public onlyGuardian {
        auditHistory = IAuditHistory(_auditHistoryAddress);
        emit AuditHistoryAddressUpdated(_auditHistoryAddress);
    }

    function initiateRecovery(
        string memory _requiredImprovement,
        uint256 _durationInSeconds
    ) public payable returns (uint256) {
        require(msg.value > 0, "Collateral must be greater than zero.");
        totalCases++;
        cases[totalCases] = RecoveryCase({
            institution: msg.sender,
            collateralAmount: msg.value,
            requiredImprovement: _requiredImprovement,
            expirationTime: block.timestamp + _durationInSeconds,
            isResolved: false
        });

        emit RecoveryInitiated(totalCases, msg.sender, msg.value);
        return totalCases;
    }

    function approveRecovery(uint256 _caseId) public onlyGuardian {
        require(_caseId > 0 && _caseId <= totalCases, "Error: Case context non-existent.");
        RecoveryCase storage c = cases[_caseId];
        require(!c.isResolved, "Error: Case already resolved.");

        c.isResolved = true;
        (bool success, ) = payable(publicBenefitVault).call{value: c.collateralAmount}("");
        require(success, "Transfer failed");

        emit RecoveryApproved(_caseId, c.collateralAmount);
    }

    function forfeitCollateral(uint256 _caseId) public onlyGuardian {
        require(_caseId > 0 && _caseId <= totalCases, "Error: Case context non-existent.");
        RecoveryCase storage c = cases[_caseId];
        require(!c.isResolved, "Error: Case already resolved.");
        require(block.timestamp > c.expirationTime, "Error: Institution still has time to comply.");

        c.isResolved = true;
        address penaltyTarget = c.institution;
        uint256 amount = c.collateralAmount;

        (bool success, ) = payable(publicBenefitVault).call{value: amount}("");
        require(success, "Transfer failed");

        emit CollateralForfeited(_caseId, penaltyTarget, amount);

        if (address(auditHistory) != address(0)) {
            try auditHistory.logHistoricalAction(penaltyTarget, 1, 0, 0, "COLLATERAL_FORFEITED_BREACH") {} catch {}
        }
    }
}
