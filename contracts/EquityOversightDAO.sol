// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title EquityOversightDAO
/// @notice DAO for encoding citizen complaints and policy breaches
contract EquityOversightDAO {
    address public oversightCommittee;
    uint256 public complaintCount;

    struct Complaint {
        uint256 id;
        address citizen;
        string details;
        bool resolved;
        uint256 timestamp;
    }

    mapping(uint256 => Complaint) public complaints;

    event ComplaintFiled(uint256 indexed id, address indexed citizen, string details);
    event ComplaintResolved(uint256 indexed id, address indexed resolver);

    modifier onlyOversight() {
        require(msg.sender == oversightCommittee, "Not authorized");
        _;
    }

    constructor(address _oversightCommittee) {
        oversightCommittee = _oversightCommittee;
    }

    /// @notice Citizens file complaints into the DAO
    function fileComplaint(string calldata details) external {
        complaintCount++;
        complaints[complaintCount] = Complaint({
            id: complaintCount,
            citizen: msg.sender,
            details: details,
            resolved: false,
            timestamp: block.timestamp
        });
        emit ComplaintFiled(complaintCount, msg.sender, details);
    }

    /// @notice Oversight Committee resolves complaints
    function resolveComplaint(uint256 id) external onlyOversight {
        Complaint storage c = complaints[id];
        require(!c.resolved, "Already resolved");
        c.resolved = true;
        emit ComplaintResolved(id, msg.sender);
    }

    /// @notice Citizens can view complaint details
    function viewComplaint(uint256 id) external view returns (Complaint memory) {
        return complaints[id];
    }
}
