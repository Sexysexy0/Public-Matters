// contracts/WageFairness.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title WageFairness
 * @notice Protocol for wage equity and communal audit of salaries.
 */
contract WageFairness {
    address public admin;

    struct WageRecord {
        string sector;
        uint256 averageWage;
        uint256 timestamp;
    }

    WageRecord[] public records;

    event WageLogged(string sector, uint256 averageWage, uint256 timestamp);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function logWage(string calldata sector, uint256 averageWage) external onlyAdmin {
        records.push(WageRecord(sector, averageWage, block.timestamp));
        emit WageLogged(sector, averageWage, block.timestamp);
    }

    function totalRecords() external view returns (uint256) {
        return records.length;
    }

    function getRecord(uint256 id) external view returns (WageRecord memory) {
        require(id < records.length, "Invalid id");
        return records[id];
    }
}
