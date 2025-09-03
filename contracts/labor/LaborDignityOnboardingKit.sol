// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LaborDignityOnboardingKit {
    struct Steward {
        string name;
        bool hasBarangayPass;
        bool isHealthy;
        bool isWillingToWork;
    }

    mapping(address => Steward) public applicants;

    function onboardSteward(
        address _steward,
        string memory _name,
        bool _hasBarangayPass,
        bool _isHealthy,
        bool _isWillingToWork
    ) public {
        applicants[_steward] = Steward(_name, _hasBarangayPass, _isHealthy, _isWillingToWork);
    }

    function isEligible(address _steward) public view returns (bool) {
        Steward memory s = applicants[_steward];
        return s.hasBarangayPass && s.isHealthy && s.isWillingToWork;
    }
}
