// contracts/PrivacyDignity.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title PrivacyDignity
 * @notice Protocol for communal dignity in digital privacy.
 */
contract PrivacyDignity {
    address public admin;

    struct Record {
        string entity;
        string measure;     // "Encryption", "DataMinimization"
        string status;      // "Implemented", "Pending"
        uint256 timestamp;
    }

    Record[] public records;

    event RecordLogged(string entity, string measure, string status, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logRecord(string calldata entity, string calldata measure, string calldata status) external onlyAdmin {
        records.push(Record(entity, measure, status, block.timestamp));
        emit RecordLogged(entity, measure, status, block.timestamp);
    }

    function totalRecords() external view returns (uint256) { return records.length; }

    function getRecord(uint256 id) external view returns (Record memory) {
        require(id < records.length, "Invalid id");
        return records[id];
    }
}
