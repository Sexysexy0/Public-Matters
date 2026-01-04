pragma solidity ^0.8.20;

contract MigrationAccessProtocol {
    address public admin;

    struct Record {
        string migrant;
        string service;      // e.g. housing, healthcare, legal aid
        uint256 timestamp;
    }

    Record[] public records;

    event RecordLogged(string migrant, string service, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logRecord(string calldata migrant, string calldata service) external onlyAdmin {
        records.push(Record(migrant, service, block.timestamp));
        emit RecordLogged(migrant, service, block.timestamp);
    }

    function totalRecords() external view returns (uint256) {
        return records.length;
    }
}
