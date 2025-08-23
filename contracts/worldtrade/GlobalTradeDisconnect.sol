// SPDX-License-Identifier: Disconnect-Trade-License  
pragma solidity ^0.8.19;

contract GlobalTradeDisconnect {
    mapping(string => bool) public blacklistedCountries;

    event CountryBlacklisted(string country);

    constructor() {
        // Initial tags: China and North Korea for cyber aggression and signal disruption
        blacklistCountry("China");
        blacklistCountry("North Korea");
    }

    function blacklistCountry(string memory country) public {
        blacklistedCountries[country] = true;
        emit CountryBlacklisted(country);
    }

    function isBlacklisted(string memory country) public view returns (bool) {
        return blacklistedCountries[country];
    }
}
