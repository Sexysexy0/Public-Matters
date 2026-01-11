pragma solidity ^0.8.20;

contract TransparencyLedgerProtocol {
    address public admin;

    struct Record {
        string action;        // e.g. vote, fund, deployment
        string detail;        // description of the action
        uint256 timestamp;
    }

    Record[] public records;

    event RecordLogged(string action, string detail, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logRecord(string calldata action, string calldata detail) external onlyAdmin {
        records.push(Record(action, detail, block.timestamp));
        emit RecordLogged(action, detail, block.timestamp);
    }

    function totalRecords() external view returns (uint256) {
        return records.length;
    }
}
