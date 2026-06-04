// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title AuditChain
/// @notice Covenant contract to log immutable audit records for tax allocations and citizen votes
contract AuditChain {
    address public owner;

    struct AuditRecord {
        string action;       // e.g. "Citizen Vote", "Tax Allocation"
        string details;      // description of the action
        uint256 timestamp;
    }

    AuditRecord[] public records;

    event AuditLogged(string action, string details, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice Log an audit record
    function logAudit(string memory action, string memory details) public onlyOwner {
        AuditRecord memory newRecord = AuditRecord(action, details, block.timestamp);
        records.push(newRecord);
        emit AuditLogged(action, details, block.timestamp);
    }

    function getRecord(uint256 index) public view returns (string memory, string memory, uint256) {
        AuditRecord memory r = records[index];
        return (r.action, r.details, r.timestamp);
    }

    function getRecordCount() public view returns (uint256) {
        return records.length;
    }
}
