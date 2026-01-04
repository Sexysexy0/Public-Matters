pragma solidity ^0.8.20;

contract AccountabilityDashboardProtocol {
    address public admin;

    struct Entry {
        string category;   // corruption, election, funds
        string detail;
        uint256 timestamp;
    }

    Entry[] public entries;

    event EntryLogged(string category, string detail, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logEntry(string calldata category, string calldata detail) external onlyAdmin {
        entries.push(Entry(category, detail, block.timestamp));
        emit EntryLogged(category, detail, block.timestamp);
    }

    function totalEntries() external view returns (uint256) {
        return entries.length;
    }
}
