// contracts/MarketReality.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title MarketReality
 * @notice Logs actual BTC highs and lows for communal audit.
 */
contract MarketReality {
    address public admin;

    struct Record {
        uint256 high;
        uint256 low;
        string note;
        uint256 timestamp;
    }

    Record[] public records;

    event RecordLogged(uint256 high, uint256 low, string note, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logRecord(uint256 high, uint256 low, string calldata note) external onlyAdmin {
        records.push(Record(high, low, note, block.timestamp));
        emit RecordLogged(high, low, note, block.timestamp);
    }

    function totalRecords() external view returns (uint256) { return records.length; }

    function getRecord(uint256 id) external view returns (Record memory) {
        require(id < records.length, "Invalid id");
        return records[id];
    }
}
