pragma solidity ^0.8.20;

contract CulturalCommonsProtocol {
    address public admin;

    struct Record {
        string tradition;    // e.g. festival, language, art form
        string status;       // e.g. preserved, endangered, revitalized
        uint256 timestamp;
    }

    Record[] public records;

    event RecordLogged(string tradition, string status, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logRecord(string calldata tradition, string calldata status) external onlyAdmin {
        records.push(Record(tradition, status, block.timestamp));
        emit RecordLogged(tradition, status, block.timestamp);
    }

    function totalRecords() external view returns (uint256) {
        return records.length;
    }
}
