// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TaxCutBlessingDeck {
    enum BeneficiaryType { BlueCollar, SmallBusiness, Veterans, Farmers, EnergySector }
    enum BlessingType { IncomeTaxCut, PayrollRelief, InvestmentCredit, ChildTaxBoost }

    struct TaxBlessing {
        uint256 id;
        BeneficiaryType beneficiary;
        BlessingType blessingType;
        uint256 estimatedImpactUSD;
        string clauseReference;
        uint256 timestamp;
    }

    mapping(uint256 => TaxBlessing) public blessingRegistry;
    uint256 public blessingCount;

    event BlessingLogged(uint256 id, BeneficiaryType beneficiary, BlessingType blessingType);
    event ImpactUpdated(uint256 id, uint256 newImpactUSD);

    function logBlessing(
        BeneficiaryType beneficiary,
        BlessingType blessingType,
        uint256 estimatedImpactUSD,
        string memory clauseReference,
        uint256 timestamp
    ) public {
        blessingRegistry[blessingCount] = TaxBlessing(
            blessingCount,
            beneficiary,
            blessingType,
            estimatedImpactUSD,
            clauseReference,
            timestamp
        );
        emit BlessingLogged(blessingCount, beneficiary, blessingType);
        blessingCount++;
    }

    function updateImpact(uint256 id, uint256 newImpactUSD) public {
        require(id < blessingCount, "Invalid blessing ID");
        blessingRegistry[id].estimatedImpactUSD = newImpactUSD;
        emit ImpactUpdated(id, newImpactUSD);
    }

    function getBlessing(uint256 id) public view returns (TaxBlessing memory) {
        return blessingRegistry[id];
    }
}
