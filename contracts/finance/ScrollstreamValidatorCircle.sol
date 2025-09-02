// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract ScrollstreamValidatorCircle {
    struct Validator {
        address steward;
        string barangay;
        bool isActive;
    }

    mapping(address => Validator) public validators;
    address public steward;

    event ValidatorAdded(address steward, string barangay);
    event ValidatorRevoked(address steward);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized scrollcaster");
        _;
    }

    constructor(address _steward) {
        steward = _steward;
    }

    function addValidator(address _steward, string memory _barangay) public onlySteward {
        validators[_steward] = Validator(_steward, _barangay, true);
        emit ValidatorAdded(_steward, _barangay);
    }

    function revokeValidator(address _steward) public onlySteward {
        validators[_steward].isActive = false;
        emit ValidatorRevoked(_steward);
    }

    function isValidator(address _steward) public view returns (bool) {
        return validators[_steward].isActive;
    }
}
