// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ProfessionalFlowGuardian
/// @notice Guardian covenant to safeguard orchestration flow and professional alignment
contract ProfessionalFlowGuardian {
    address public oversightCommittee;
    uint256 public guardianCount;

    struct FlowRecord {
        uint256 id;
        string domain;       // e.g. work, governance, creative
        string flow;         // professional, lawful, authentic
        string restriction;  // no fabrication, no unlawful teaching
        string status;       // aligned, drift, corrected
        string notes;
        uint256 timestamp;
    }

    mapping(uint256 => FlowRecord) public records;

    event FlowGuarded(uint256 indexed id, string domain, string flow, string restriction, string status, string notes);

    modifier onlyOversight() {
        require(msg.sender == oversightCommittee, "Not authorized");
        _;
    }

    constructor(address _oversightCommittee) {
        oversightCommittee = _oversightCommittee;
    }

    /// @notice Oversight logs orchestration flow record
    function guardFlow(string calldata domain, string calldata flow, string calldata restriction, string calldata status, string calldata notes) external onlyOversight {
        guardianCount++;
        records[guardianCount] = FlowRecord({
            id: guardianCount,
            domain: domain,
            flow: flow,
            restriction: restriction,
            status: status,
            notes: notes,
            timestamp: block.timestamp
        });
        emit FlowGuarded(guardianCount, domain, flow, restriction, status, notes);
    }

    /// @notice Citizens can view flow records
    function viewFlow(uint256 id) external view returns (FlowRecord memory) {
        return records[id];
    }
}
