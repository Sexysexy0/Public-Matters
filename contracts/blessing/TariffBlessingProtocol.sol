// Treaty-grade tariff blessing contract for global corridors
pragma solidity ^0.8.30;

contract TariffBlessingProtocol {
    address public steward;
    uint256 public defaultTariff = 10; // 10% base rate
    mapping(string => uint256) public countryTariff;
    event TariffUpdated(string country, uint256 newRate);
    event EmergencyOverride(string country, uint256 overrideRate);

    constructor() {
        steward = msg.sender;
        // Initialize treaty corridors
        countryTariff["India"] = defaultTariff;
        countryTariff["Philippines"] = defaultTariff;
        countryTariff["EU"] = defaultTariff;
        countryTariff["Canada"] = defaultTariff;
        countryTariff["Taiwan"] = defaultTariff;
        countryTariff["South Korea"] = defaultTariff;
    }

    function updateTariff(string memory country, uint256 newRate) public {
        require(msg.sender == steward, "Unauthorized steward");
        countryTariff[country] = newRate;
        emit TariffUpdated(country, newRate);
    }

    function emergencyOverride(string memory country, uint256 overrideRate) public {
        require(msg.sender == steward, "Unauthorized override");
        countryTariff[country] = overrideRate;
        emit EmergencyOverride(country, overrideRate);
    }

    function getTariff(string memory country) public view returns (uint256) {
        return countryTariff[country];
    }
}
