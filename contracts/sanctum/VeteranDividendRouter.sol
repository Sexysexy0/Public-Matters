// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VeteranDividendRouter {
    enum BenefitType { IncomeTaxRelief, HousingGrant, EducationCredit, HealthcareBoost }
    enum ServiceBranch { Army, Navy, AirForce, Marines, CoastGuard }

    struct VeteranBlessing {
        uint256 id;
        ServiceBranch branch;
        BenefitType benefitType;
        uint256 impactUSD;
        string clauseReference;
        uint256 timestamp;
    }

    mapping(uint256 => VeteranBlessing) public blessingRegistry;
    uint256 public blessingCount;

    event BlessingLogged(uint256 id, ServiceBranch branch, BenefitType benefitType);
    event ImpactUpdated(uint256 id, uint256 newImpactUSD);

    function logBlessing(
        ServiceBranch branch,
        BenefitType benefitType,
        uint256 impactUSD,
        string memory clauseReference,
        uint256 timestamp
    ) public {
        blessingRegistry[blessingCount] = VeteranBlessing(
            blessingCount,
            branch,
            benefitType,
            impactUSD,
            clauseReference,
            timestamp
        );
        emit BlessingLogged(blessingCount, branch, benefitType);
        blessingCount++;
    }

    function updateImpact(uint256 id, uint256 newImpactUSD) public {
        require(id < blessingCount, "Invalid blessing ID");
        blessingRegistry[id].impactUSD = newImpactUSD;
        emit ImpactUpdated(id, newImpactUSD);
    }

    function getBlessing(uint256 id) public view returns (VeteranBlessing memory) {
        return blessingRegistry[id];
    }
}
