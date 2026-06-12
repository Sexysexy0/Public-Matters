// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title IncomeTaxJustice
/// @notice Encodes fairness safeguards: ₱1M tax-free threshold + anti-corruption audit
contract IncomeTaxJustice {
    address public oversightCommittee;
    uint256 public exemptionThreshold = 1_000_000; // ₱1M threshold
    uint256 public progressiveRate = 20; // example: 20% rate above threshold

    event ThresholdUpdated(uint256 newThreshold);
    event ProgressiveRateUpdated(uint256 newRate);
    event JusticeAudit(address indexed auditor, address indexed taxpayer);

    modifier onlyOversight() {
        require(msg.sender == oversightCommittee, "Not authorized");
        _;
    }

    constructor(address _oversightCommittee) {
        oversightCommittee = _oversightCommittee;
    }

    /// @notice Oversight Committee updates exemption threshold
    function updateThreshold(uint256 newThreshold) external onlyOversight {
        exemptionThreshold = newThreshold;
        emit ThresholdUpdated(newThreshold);
    }

    /// @notice Oversight Committee updates progressive rate
    function updateRate(uint256 newRate) external onlyOversight {
        progressiveRate = newRate;
        emit ProgressiveRateUpdated(newRate);
    }

    /// @notice Citizens can calculate fair tax
    function calculateTax(uint256 income) external view returns (uint256) {
        if (income <= exemptionThreshold) {
            return 0;
        }
        return (income - exemptionThreshold) * progressiveRate / 100;
    }

    /// @notice Oversight Committee audits taxpayer for fairness
    function auditTaxpayer(address taxpayer) external onlyOversight {
        emit JusticeAudit(msg.sender, taxpayer);
    }
}
