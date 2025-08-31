// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.19;

contract TrustCalibrationProtocol {
    struct CountryPair {
        string country;
        bool isReady;
        uint emotionalAPR;
        bool damayClauseActive;
    }

    mapping(string => CountryPair) public pairings;

    function calibrateTrust(string memory _country, uint _emotionalAPR, bool _damayClause) public {
        require(_emotionalAPR <= 100, "APR must be between 0-100");
        pairings[_country] = CountryPair(_country, true, _emotionalAPR, _damayClause);
    }

    function overrideTrigger(string memory _country) public view returns (bool) {
        return pairings[_country].emotionalAPR < 40;
    }
}
