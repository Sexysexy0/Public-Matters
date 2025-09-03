// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EmployerBlessingProtocol {
    struct Employer {
        string name;
        bool coversMedical;
        bool honorsZeroBarrierTreaty;
        bool emotionallyTagged;
    }

    mapping(address => Employer) public registry;

    function blessEmployer(
        address _employer,
        string memory _name,
        bool _coversMedical,
        bool _honorsZeroBarrierTreaty,
        bool _emotionallyTagged
    ) public {
        registry[_employer] = Employer(_name, _coversMedical, _honorsZeroBarrierTreaty, _emotionallyTagged);
    }

    function isBlessed(address _employer) public view returns (bool) {
        Employer memory e = registry[_employer];
        return e.coversMedical && e.honorsZeroBarrierTreaty && e.emotionallyTagged;
    }
}
