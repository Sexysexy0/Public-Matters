// SPDX-License-Identifier: CannabisRevenueSanctum
pragma solidity ^0.8.19;

contract CannabisTaxSanctifier {
    struct DispensaryRevenue {
        string dispensaryID;
        uint256 grossSales;
        uint256 taxRate;
        uint256 taxDue;
        bool taxPaid;
        string stewardNote;
    }

    mapping(string => DispensaryRevenue) public revenueLedger;

    event TaxTagged(string dispensaryID, uint256 taxDue);
    event TaxSanctified(string dispensaryID);

    function tagRevenue(string memory dispensaryID, uint256 grossSales, uint256 taxRate, string memory stewardNote) public {
        uint256 taxDue = (grossSales * taxRate) / 100;
        revenueLedger[dispensaryID] = DispensaryRevenue(dispensaryID, grossSales, taxRate, taxDue, false, stewardNote);
        emit TaxTagged(dispensaryID, taxDue);
    }

    function sanctifyTax(string memory dispensaryID) public {
        require(revenueLedger[dispensaryID].taxDue > 0, "No tax due");
        revenueLedger[dispensaryID].taxPaid = true;
        emit TaxSanctified(dispensaryID);
    }

    function getRevenueStatus(string memory dispensaryID) public view returns (DispensaryRevenue memory) {
        return revenueLedger[dispensaryID];
    }
}
