// contracts/TransparencyCommons.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title TransparencyCommons
 * @notice Communal transparency ledger for media and public narratives.
 */
contract TransparencyCommons {
    address public admin;

    struct Entry {
        string subject;
        string detail;
        uint256 timestamp;
    }

    Entry[] public entries;

    event EntryLogged(string subject, string detail, uint256 timestamp);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function logEntry(string calldata subject, string calldata detail) external onlyAdmin {
        entries.push(Entry(subject, detail, block.timestamp));
        emit EntryLogged(subject, detail, block.timestamp);
    }

    function totalEntries() external view returns (uint256) {
        return entries.length;
    }

    function getEntry(uint256 id) external view returns (Entry memory) {
        require(id < entries.length, "Invalid id");
        return entries[id];
    }
}
