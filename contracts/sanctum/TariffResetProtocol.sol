// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TariffResetProtocol {
    enum Region { UnitedStates, Philippines, China, India, Japan, SouthKorea, EU }
    enum TariffStatus { Active, Revoked, Reset }

    struct TariffRecord {
        uint256 id;
        Region origin;
        Region destination;
        string goodsCategory;
        uint256 originalRate;
        uint256 resetRate;
        TariffStatus status;
        string rollbackClause;
        uint256 resetDate;
    }

    mapping(uint256 => TariffRecord) public tariffRegistry;
    uint256 public tariffCount;

    event TariffRevoked(uint256 id, Region origin, Region destination);
    event TariffReset(uint256 id, uint256 resetRate);

    function revokeTariff(
        Region origin,
        Region destination,
        string memory goodsCategory,
        uint256 originalRate,
        string memory rollbackClause,
        uint256 resetDate
    ) public {
        tariffRegistry[tariffCount] = TariffRecord(
            tariffCount,
            origin,
            destination,
            goodsCategory,
            originalRate,
            0,
            TariffStatus.Revoked,
            rollbackClause,
            resetDate
        );
        emit TariffRevoked(tariffCount, origin, destination);
        tariffCount++;
    }

    function resetTariff(uint256 id, uint256 resetRate) public {
        require(id < tariffCount, "Invalid tariff ID");
        tariffRegistry[id].resetRate = resetRate;
        tariffRegistry[id].status = TariffStatus.Reset;
        emit TariffReset(id, resetRate);
    }

    function getTariff(uint256 id) public view returns (TariffRecord memory) {
        return tariffRegistry[id];
    }
}
