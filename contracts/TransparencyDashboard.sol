// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title TransparencyDashboard
/// @notice Covenant contract to provide public visibility of audit logs and allocations
contract TransparencyDashboard {
    address public owner;

    struct DashboardEntry {
        string category;     // e.g. "Vote", "Allocation", "Audit"
        string details;      // description of the action
        uint256 amount;      // optional funds involved
        uint256 timestamp;   // block timestamp
    }

    DashboardEntry[] public entries;

    event EntryAdded(string category, string details, uint256 amount, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function addEntry(string memory category, string memory details, uint256 amount) public onlyOwner {
        DashboardEntry memory newEntry = DashboardEntry(category, details, amount, block.timestamp);
        entries.push(newEntry);
        emit EntryAdded(category, details, amount, block.timestamp);
    }

    function getEntry(uint256 index) public view returns (string memory, string memory, uint256, uint256) {
        DashboardEntry memory entry = entries[index];
        return (entry.category, entry.details, entry.amount, entry.timestamp);
    }

    function getEntryCount() public view returns (uint256) {
        return entries.length;
    }
}
