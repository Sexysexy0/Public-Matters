pragma solidity ^0.8.20;

contract TaxJusticeProtocol {
    address public admin;

    struct Record {
        string taxpayer;     // e.g. corporation, individual
        uint256 amount;
        string status;       // e.g. paid, evaded, audited
        uint256 timestamp;
    }

    Record[] public records;

    event RecordLogged(string taxpayer, uint256 amount, string status, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logRecord(string calldata taxpayer, uint256 amount, string calldata status) external onlyAdmin {
        records.push(Record(taxpayer, amount, status, block.timestamp));
        emit RecordLogged(taxpayer, amount, status, block.timestamp);
    }

    function totalRecords() external view returns (uint256) {
        return records.length;
    }
}
