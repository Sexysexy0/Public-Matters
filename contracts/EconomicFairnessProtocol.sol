pragma solidity ^0.8.20;

contract EconomicFairnessProtocol {
    address public admin;

    struct Record {
        string sector;       // e.g. housing, healthcare, wages
        string measure;      // e.g. subsidy, wage increase, tax relief
        uint256 timestamp;
    }

    Record[] public records;

    event RecordLogged(string sector, string measure, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logRecord(string calldata sector, string calldata measure) external onlyAdmin {
        records.push(Record(sector, measure, block.timestamp));
        emit RecordLogged(sector, measure, block.timestamp);
    }

    function totalRecords() external view returns (uint256) {
        return records.length;
    }
}
