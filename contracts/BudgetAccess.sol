// contracts/BudgetAccess.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title BudgetAccess
 * @notice Logs communal access to government budgets and allocations.
 */
contract BudgetAccess {
    address public admin;

    struct Entry {
        string department;  // "Education", "Healthcare", "Infrastructure"
        uint256 amount;     // in millions
        string status;      // "Accessible", "Restricted"
        uint256 timestamp;
    }

    Entry[] public entries;

    event EntryLogged(string department, uint256 amount, string status, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logEntry(string calldata department, uint256 amount, string calldata status) external onlyAdmin {
        entries.push(Entry(department, amount, status, block.timestamp));
        emit EntryLogged(department, amount, status, block.timestamp);
    }

    function totalEntries() external view returns (uint256) { return entries.length; }

    function getEntry(uint256 id) external view returns (Entry memory) {
        require(id < entries.length, "Invalid id");
        return entries[id];
    }
}
