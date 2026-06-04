// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title TransparencyDashboard
/// @notice Covenant contract to provide public access to audit logs, votes, and allocations
contract TransparencyDashboard {
    address public owner;

    struct DashboardEntry {
        string category;     // e.g. "Audit", "Citizen Vote", "Tax Allocation", "Flag"
        string details;      // description of the record
        uint256 amount;      // optional value (0 if not applicable)
        uint256 timestamp;
    }

    DashboardEntry[] public entries;

    event EntryLogged(string category, string details, uint256 amount, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice Log a new entry to the dashboard
    function logEntry(string memory category, string memory details, uint256 amount) public onlyOwner {
        DashboardEntry memory newEntry = DashboardEntry(category, details, amount, block.timestamp);
        entries.push(newEntry);
        emit EntryLogged(category, details, amount, block.timestamp);
    }

    function getEntry(uint256 index) public view returns (string memory, string memory, uint256, uint256) {
        DashboardEntry memory e = entries[index];
        return (e.category, e.details, e.amount, e.timestamp);
    }

    function getEntryCount() public view returns (uint256) {
        return entries.length;
    }
}
