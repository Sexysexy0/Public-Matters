// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DebtShieldSanctum {
    enum DebtType { StudentLoan, MedicalDebt, CreditCard, Mortgage }
    enum ReliefMethod { Forgiveness, InterestCap, PaymentPause, Subsidy }

    struct DebtBlessing {
        uint256 id;
        DebtType debtType;
        ReliefMethod reliefMethod;
        uint256 impactUSD;
        string clauseReference;
        uint256 timestamp;
    }

    mapping(uint256 => DebtBlessing) public blessingRegistry;
    uint256 public blessingCount;

    event BlessingLogged(uint256 id, DebtType debtType, ReliefMethod reliefMethod);
    event ImpactUpdated(uint256 id, uint256 newImpactUSD);

    function logBlessing(
        DebtType debtType,
        ReliefMethod reliefMethod,
        uint256 impactUSD,
        string memory clauseReference,
        uint256 timestamp
    ) public {
        blessingRegistry[blessingCount] = DebtBlessing(
            blessingCount,
            debtType,
            reliefMethod,
            impactUSD,
            clauseReference,
            timestamp
        );
        emit BlessingLogged(blessingCount, debtType, reliefMethod);
        blessingCount++;
    }

    function updateImpact(uint256 id, uint256 newImpactUSD) public {
        require(id < blessingCount, "Invalid blessing ID");
        blessingRegistry[id].impactUSD = newImpactUSD;
        emit ImpactUpdated(id, newImpactUSD);
    }

    function getBlessing(uint256 id) public view returns (DebtBlessing memory) {
        return blessingRegistry[id];
    }
}
