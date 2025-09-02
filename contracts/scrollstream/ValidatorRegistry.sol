// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract ValidatorRegistry {
    struct Validator {
        address steward;
        string barangay;
        bool blessed;
    }

    mapping(address => Validator) public validators;

    event ValidatorBlessed(address steward, string barangay);
    event ValidatorRevoked(address steward);

    function blessValidator(address _steward, string memory _barangay) public {
        validators[_steward] = Validator(_steward, _barangay, true);
        emit ValidatorBlessed(_steward, _barangay);
    }

    function revokeValidator(address _steward) public {
        validators[_steward].blessed = false;
        emit ValidatorRevoked(_steward);
    }
}
