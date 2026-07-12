// SPDX-License-Identifier: MIT
// Contract Name: FairProfitCovenant
// Purpose: Encode fair commission model for digital platforms (Steam case study)
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract FairProfitCovenant {
    address public chiefOperator;
    uint256 public commissionRate; // expressed in percentage (e.g. 15 = 15%)

    struct ProfitRecord {
        string platform;    // e.g. Steam, Epic, GOG
        uint256 saleAmount; // gross sale amount
        uint256 commission; // commission taken
        uint256 netRevenue; // revenue left for developer
        uint256 timestamp;
    }

    ProfitRecord[] public records;

    event ProfitLogged(string platform, uint256 saleAmount, uint256 commission, uint256 netRevenue, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        commissionRate = 15; // default commission set to 15%
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    function setCommissionRate(uint256 newRate) public onlyChief {
        require(newRate <= 100, "Invalid commission rate");
        commissionRate = newRate;
    }

    function logSale(string memory platform, uint256 saleAmount) public onlyChief {
        uint256 commission = (saleAmount * commissionRate) / 100;
        uint256 netRevenue = saleAmount - commission;
        records.push(ProfitRecord(platform, saleAmount, commission, netRevenue, block.timestamp));
        emit ProfitLogged(platform, saleAmount, commission, netRevenue, block.timestamp);
    }

    function getRecord(uint256 index) public view returns (
        string memory, uint256, uint256, uint256, uint256
    ) {
        require(index < records.length, "Invalid record index");
        ProfitRecord memory pr = records[index];
        return (pr.platform, pr.saleAmount, pr.commission, pr.netRevenue, pr.timestamp);
    }
}
