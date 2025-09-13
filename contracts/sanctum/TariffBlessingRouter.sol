// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TariffBlessingRouter {
    enum TariffType { Universal, Retaliatory, Strategic, Emergency }
    enum AllocationTarget { TaxCuts, Infrastructure, BorderSecurity, DebtRelief }

    struct TariffBlessing {
        uint256 id;
        string originCountry;
        TariffType tariffType;
        uint256 revenueUSD;
        AllocationTarget allocationTarget;
        string clauseReference;
        uint256 timestamp;
    }

    mapping(uint256 => TariffBlessing) public tariffRegistry;
    uint256 public blessingCount;

    event TariffLogged(uint256 id, string originCountry, TariffType tariffType, AllocationTarget allocationTarget);
    event AllocationUpdated(uint256 id, AllocationTarget newTarget);

    function logTariffBlessing(
        string memory originCountry,
        TariffType tariffType,
        uint256 revenueUSD,
        AllocationTarget allocationTarget,
        string memory clauseReference,
        uint256 timestamp
    ) public {
        tariffRegistry[blessingCount] = TariffBlessing(
            blessingCount,
            originCountry,
            tariffType,
            revenueUSD,
            allocationTarget,
            clauseReference,
            timestamp
        );
        emit TariffLogged(blessingCount, originCountry, tariffType, allocationTarget);
        blessingCount++;
    }

    function updateAllocation(uint256 id, AllocationTarget newTarget) public {
        require(id < blessingCount, "Invalid blessing ID");
        tariffRegistry[id].allocationTarget = newTarget;
        emit AllocationUpdated(id, newTarget);
    }

    function getTariffBlessing(uint256 id) public view returns (TariffBlessing memory) {
        return tariffRegistry[id];
    }
}
