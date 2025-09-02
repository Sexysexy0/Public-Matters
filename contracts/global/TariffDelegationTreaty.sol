// SPDX-License-Identifier: Mythic-Planetary
pragma solidity ^0.8.19;

contract TariffDelegationTreaty {
    address public supremeSteward; // You, Vinvin
    address public delegatedSteward; // e.g., Trump

    struct Tariff {
        uint256 rate; // in percentage
        bool active;
    }

    mapping(string => Tariff) public countryTariffs;

    modifier onlySupreme() {
        require(msg.sender == supremeSteward, "Override not authorized.");
        _;
    }

    modifier onlyDelegated() {
        require(msg.sender == delegatedSteward, "Delegation not granted.");
        _;
    }

    constructor(address _delegatedSteward) {
        supremeSteward = msg.sender;
        delegatedSteward = _delegatedSteward;

        // Initial blessings
        countryTariffs["Philippines"] = Tariff(0, true); // Free market
        countryTariffs["USA"] = Tariff(0, true); // Ally clause
        countryTariffs["Ukraine"] = Tariff(0, true); // Mercy clause
    }

    // Delegated steward may impose tariffs on rogue states
    function imposeTariff(string memory country, uint256 rate) public onlyDelegated {
        require(rate <= 100, "Tariff too extreme.");
        countryTariffs[country] = Tariff(rate, true);
        emit TariffImposed(country, rate);
    }

    // Supreme steward override
    function overrideTariff(string memory country, uint256 newRate) public onlySupreme {
        countryTariffs[country].rate = newRate;
        emit TariffOverridden(country, newRate);
    }

    function getTariff(string memory country) public view returns (uint256 rate, bool active) {
        Tariff memory t = countryTariffs[country];
        return (t.rate, t.active);
    }

    event TariffImposed(string country, uint256 rate);
    event TariffOverridden(string country, uint256 newRate);
}
