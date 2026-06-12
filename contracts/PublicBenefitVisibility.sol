// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title PublicBenefitVisibility
/// @notice Ensures every peso of tax revenue is transparently tracked
contract PublicBenefitVisibility {
    address public oversightCommittee;
    mapping(uint256 => string) public expenditureLogs;
    uint256 public logCount;

    event ExpenditureLogged(uint256 indexed logId, string details);
    event OversightAudit(address indexed auditor, uint256 indexed logId);

    modifier onlyOversight() {
        require(msg.sender == oversightCommittee, "Not authorized");
        _;
    }

    constructor(address _oversightCommittee) {
        oversightCommittee = _oversightCommittee;
    }

    /// @notice Citizens can view all expenditure logs
    function viewLog(uint256 logId) external view returns (string memory) {
        return expenditureLogs[logId];
    }

    /// @notice Oversight Committee encodes expenditure transparency
    function logExpenditure(string calldata details) external onlyOversight {
        logCount++;
        expenditureLogs[logCount] = details;
        emit ExpenditureLogged(logCount, details);
    }

    /// @notice Oversight Committee audits specific expenditure
    function auditExpenditure(uint256 logId) external onlyOversight {
        emit OversightAudit(msg.sender, logId);
    }
}
