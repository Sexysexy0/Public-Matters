// contracts/FuelAudit.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title FuelAudit
 * @notice Tracks fossil fuel usage and communal equity in energy transition.
 */
contract FuelAudit {
    address public admin;

    struct Record {
        string fuelType;    // "Coal", "Oil", "Gas"
        uint256 usage;      // in metric tons
        string verdict;     // "High", "Low", "Declining"
        uint256 timestamp;
    }

    Record[] public records;

    event RecordLogged(string fuelType, uint256 usage, string verdict, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logRecord(string calldata fuelType, uint256 usage, string calldata verdict) external onlyAdmin {
        records.push(Record(fuelType, usage, verdict, block.timestamp));
        emit RecordLogged(fuelType, usage, verdict, block.timestamp);
    }

    function totalRecords() external view returns (uint256) { return records.length; }

    function getRecord(uint256 id) external view returns (Record memory) {
        require(id < records.length, "Invalid id");
        return records[id];
    }
}
