// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract KinderQueenLaborTreatyKit {
    struct FamilySteward {
        string name;
        uint age;
        bool isHealthy;
        bool isWillingToWork;
        bool hasBarangayBlessing;
    }

    mapping(address => FamilySteward) public registry;

    function onboardFamilySteward(
        address _steward,
        string memory _name,
        uint _age,
        bool _isHealthy,
        bool _isWillingToWork,
        bool _hasBarangayBlessing
    ) public {
        registry[_steward] = FamilySteward(_name, _age, _isHealthy, _isWillingToWork, _hasBarangayBlessing);
    }

    function isEligible(address _steward) public view returns (bool) {
        FamilySteward memory s = registry[_steward];
        return s.age >= 18 && s.isHealthy && s.isWillingToWork && s.hasBarangayBlessing;
    }
}
