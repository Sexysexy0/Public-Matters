// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EmployerMedicalResponsibility {
    struct Employer {
        string name;
        bool coversMedical;
    }

    mapping(address => Employer) public employers;

    function registerEmployer(address _employer, string memory _name, bool _coversMedical) public {
        employers[_employer] = Employer(_name, _coversMedical);
    }

    function isCompliant(address _employer) public view returns (bool) {
        return employers[_employer].coversMedical;
    }
}
