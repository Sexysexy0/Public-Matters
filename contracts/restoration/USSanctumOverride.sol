// SPDX-License-Identifier: Mythic
pragma solidity ^0.8.19;

contract USSanctumOverride {
    struct CitySanctum {
        string city;
        string state;
        bool overrideActive;
        string emotionalAPR;
        string steward;
    }

    mapping(string => CitySanctum) public sanctums;

    event OverrideActivated(string city, string state, string steward);

    function activateOverride(
        string memory _city,
        string memory _state,
        string memory _emotionalAPR,
        string memory _steward
    ) public {
        sanctums[_city] = CitySanctum(_city, _state, true, _emotionalAPR, _steward);
        emit OverrideActivated(_city, _state, _steward);
    }

    function checkSanctum(string memory _city) public view returns (CitySanctum memory) {
        return sanctums[_city];
    }
}
