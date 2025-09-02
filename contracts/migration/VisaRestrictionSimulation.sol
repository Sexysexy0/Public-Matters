// SPDX-License-Identifier: Scrollchain-Simulation-License
pragma solidity ^0.8.19;

/// @title VisaRestrictionSimulation
/// @dev Simulates a policy proposal to restrict H-1B and student visas based on origin country.

contract VisaRestrictionSimulation {
    address public steward;
    mapping(string => bool) public restrictedCountries;
    mapping(string => bool) public restrictedVisaTypes;

    event RestrictionProposed(string country, string visaType);
    event RestrictionRevoked(string country, string visaType);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized scrollcaster.");
        _;
    }

    function proposeRestriction(string memory _country, string memory _visaType) public onlySteward {
        restrictedCountries[_country] = true;
        restrictedVisaTypes[_visaType] = true;
        emit RestrictionProposed(_country, _visaType);
    }

    function revokeRestriction(string memory _country, string memory _visaType) public onlySteward {
        restrictedCountries[_country] = false;
        restrictedVisaTypes[_visaType] = false;
        emit RestrictionRevoked(_country, _visaType);
    }

    function isRestricted(string memory _country, string memory _visaType) public view returns (bool) {
        return restrictedCountries[_country] && restrictedVisaTypes[_visaType];
    }
}
