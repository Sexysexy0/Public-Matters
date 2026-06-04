// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title IncomeTaxJustice
/// @notice Covenant contract to enforce ₱1M tax-free threshold and ensure transparency
contract IncomeTaxJustice {
    address public owner;
    uint256 public taxFreeThreshold = 1_000_000; // ₱1M

    struct TaxRecord {
        address citizen;
        uint256 income;
        uint256 taxDue;
        uint256 timestamp;
    }

    TaxRecord[] public records;

    event TaxCalculated(address citizen, uint256 income, uint256 taxDue, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice Calculate tax based on ₱1M threshold
    function calculateTax(address citizen, uint256 income, uint256 rate) public onlyOwner {
        uint256 taxDue = 0;
        if (income > taxFreeThreshold) {
            uint256 taxableIncome = income - taxFreeThreshold;
            taxDue = (taxableIncome * rate) / 100;
        }

        TaxRecord memory newRecord = TaxRecord(citizen, income, taxDue, block.timestamp);
        records.push(newRecord);

        emit TaxCalculated(citizen, income, taxDue, block.timestamp);
    }

    function getRecord(uint256 index) public view returns (address, uint256, uint256, uint256) {
        TaxRecord memory r = records[index];
        return (r.citizen, r.income, r.taxDue, r.timestamp);
    }

    function getRecordCount() public view returns (uint256) {
        return records.length;
    }
}
