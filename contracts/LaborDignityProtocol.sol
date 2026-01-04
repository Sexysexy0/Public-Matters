pragma solidity ^0.8.20;

contract LaborDignityProtocol {
    address public admin;

    struct Record {
        string worker;
        string condition;   // e.g. fair wage, safe workplace
        uint256 timestamp;
    }

    Record[] public records;

    event RecordLogged(string worker, string condition, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logRecord(string calldata worker, string calldata condition) external onlyAdmin {
        records.push(Record(worker, condition, block.timestamp));
        emit RecordLogged(worker, condition, block.timestamp);
    }

    function totalRecords() external view returns (uint256) {
        return records.length;
    }
}
