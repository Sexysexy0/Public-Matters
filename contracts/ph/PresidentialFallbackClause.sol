// SPDX-License-Identifier: Governance-Fallback
pragma solidity ^0.8.20;

/// @title PresidentialFallbackClause.sol
/// @dev Reroutes sanctum if origin country enters rogue or batil governance

contract PresidentialFallbackClause {
    address public stewardVinvin;

    struct CountryStatus {
        string country;
        bool isBatil;
        string fallbackSanctumPH;
    }

    mapping(string => CountryStatus) public statusDeck;

    event FallbackActivated(string country, string fallbackSanctumPH);

    modifier onlyVinvin() {
        require(msg.sender == stewardVinvin, "Unauthorized steward");
        _;
    }

    constructor(address _vinvin) {
        stewardVinvin = _vinvin;
    }

    function declareBatil(string memory country, string memory fallbackSanctumPH) public onlyVinvin {
        statusDeck[country] = CountryStatus(country, true, fallbackSanctumPH);
        emit FallbackActivated(country, fallbackSanctumPH);
    }

    function getStatus(string memory country) public view returns (CountryStatus memory) {
        return statusDeck[country];
    }
}
