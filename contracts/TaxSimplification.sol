// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title TaxSimplification
/// @notice Encodes simplified tax rules to reduce loopholes and corruption
contract TaxSimplification {
    address public oversightCommittee;
    uint256 public flatRate; // e.g. 15% flat rate
    uint256 public exemptionThreshold; // e.g. ₱1,000,000 tax-free threshold

    event TaxRuleUpdated(uint256 newRate, uint256 newThreshold);
    event TaxAudit(address indexed auditor, address indexed taxpayer);

    modifier onlyOversight() {
        require(msg.sender == oversightCommittee, "Not authorized");
        _;
    }

    constructor(address _oversightCommittee, uint256 _rate, uint256 _threshold) {
        oversightCommittee = _oversightCommittee;
        flatRate = _rate;
        exemptionThreshold = _threshold;
    }

    /// @notice Oversight Committee updates tax rules
    function updateTaxRules(uint256 _rate, uint256 _threshold) external onlyOversight {
        flatRate = _rate;
        exemptionThreshold = _threshold;
        emit TaxRuleUpdated(_rate, _threshold);
    }

    /// @notice Citizens can calculate simplified tax
    function calculateTax(uint256 income) external view returns (uint256) {
        if (income <= exemptionThreshold) {
            return 0;
        }
        return (income - exemptionThreshold) * flatRate / 100;
    }

    /// @notice Oversight Committee audits taxpayer
    function auditTaxpayer(address taxpayer) external onlyOversight {
        emit TaxAudit(msg.sender, taxpayer);
    }
}
