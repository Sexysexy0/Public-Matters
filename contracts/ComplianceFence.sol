// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ComplianceFence
/// @notice Covenant for strict compliance guardrails across industries
contract ComplianceFence {
    address public oversightCommittee;
    uint256 public fenceCount;

    struct ComplianceRecord {
        uint256 id;
        string industry;      // e.g. finance, healthcare, business
        string regulation;    // GDPR, local law, data sovereignty
        string status;        // compliant, violation, pending
        string notes;
        uint256 timestamp;
    }

    mapping(uint256 => ComplianceRecord) public fences;

    event ComplianceLogged(uint256 indexed id, string industry, string regulation, string status, string notes);

    modifier onlyOversight() {
        require(msg.sender == oversightCommittee, "Not authorized");
        _;
    }

    constructor(address _oversightCommittee) {
        oversightCommittee = _oversightCommittee;
    }

    /// @notice Oversight logs compliance status for industry
    function logCompliance(string calldata industry, string calldata regulation, string calldata status, string calldata notes) external onlyOversight {
        fenceCount++;
        fences[fenceCount] = ComplianceRecord({
            id: fenceCount,
            industry: industry,
            regulation: regulation,
            status: status,
            notes: notes,
            timestamp: block.timestamp
        });
        emit ComplianceLogged(fenceCount, industry, regulation, status, notes);
    }

    /// @notice Citizens can view compliance records
    function viewCompliance(uint256 id) external view returns (ComplianceRecord memory) {
        return fences[id];
    }
}
