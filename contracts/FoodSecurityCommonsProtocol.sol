pragma solidity ^0.8.20;

contract FoodSecurityCommonsProtocol {
    address public admin;

    struct Record {
        string region;       // e.g. city, province
        string status;       // e.g. surplus, shortage, distributed
        uint256 timestamp;
    }

    Record[] public records;

    event RecordLogged(string region, string status, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logRecord(string calldata region, string calldata status) external onlyAdmin {
        records.push(Record(region, status, block.timestamp));
        emit RecordLogged(region, status, block.timestamp);
    }

    function totalRecords() external view returns (uint256) {
        return records.length;
    }
}
