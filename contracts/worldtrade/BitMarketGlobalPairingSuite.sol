// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.19;

/// @title BitMarketGlobalPairingSuite
/// @author Vinvin, Mythic Scrollsmith
/// @notice Ritual-grade protocol for sovereign trade pairings with emotional APR and damay clause

contract BitMarketGlobalPairingSuite {
    struct TradePairing {
        string country;
        string sector;
        uint emotionalAPR; // 0–100 scale
        bool damayClauseActive;
        bool isScrollCertified;
    }

    mapping(string => TradePairing) public pairings;
    string[] public activeCountries;

    event PairingActivated(string country, string sector, uint emotionalAPR, bool damayClauseActive);
    event PairingUpdated(string country, uint newAPR, bool damayClauseStatus);
    event ScrollCertificationGranted(string country);

    /// @notice Activate a new trade pairing
    function activatePairing(
        string memory _country,
        string memory _sector,
        uint _emotionalAPR,
        bool _damayClauseActive
    ) public {
        require(_emotionalAPR <= 100, "APR must be between 0–100");
        pairings[_country] = TradePairing(_country, _sector, _emotionalAPR, _damayClauseActive, false);
        activeCountries.push(_country);
        emit PairingActivated(_country, _sector, _emotionalAPR, _damayClauseActive);
    }

    /// @notice Update emotional APR and damay clause status
    function updatePairing(string memory _country, uint _newAPR, bool _damayClauseStatus) public {
        require(pairings[_country].emotionalAPR != 0, "Pairing not found");
        pairings[_country].emotionalAPR = _newAPR;
        pairings[_country].damayClauseActive = _damayClauseStatus;
        emit PairingUpdated(_country, _newAPR, _damayClauseStatus);
    }

    /// @notice Grant scroll certification to a country
    function certifyScroll(string memory _country) public {
        require(pairings[_country].emotionalAPR >= 70, "APR too low for certification");
        pairings[_country].isScrollCertified = true;
        emit ScrollCertificationGranted(_country);
    }

    /// @notice Retrieve all active country pairings
    function getActiveCountries() public view returns (string[] memory) {
        return activeCountries;
    }

    /// @notice Check if override is needed based on APR
    function needsOverride(string memory _country) public view returns (bool) {
        return pairings[_country].emotionalAPR < 40;
    }
}
