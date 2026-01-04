pragma solidity ^0.8.20;

contract DataPrivacyCommonsProtocol {
    address public admin;

    struct Record {
        string dataset;      // e.g. medical, financial, personal
        string action;       // e.g. encrypted, anonymized, breached
        uint256 timestamp;
    }

    Record[] public records;

    event RecordLogged(string dataset, string action, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logRecord(string calldata dataset, string calldata action) external onlyAdmin {
        records.push(Record(dataset, action, block.timestamp));
        emit RecordLogged(dataset, action, block.timestamp);
    }

    function totalRecords() external view returns (uint256) {
        return records.length;
    }
}
