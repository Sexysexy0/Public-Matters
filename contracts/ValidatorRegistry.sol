// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ValidatorRegistry
/// @notice Covenant contract to register and manage validators
contract ValidatorRegistry {
    address public sovereignContractor;

    struct Validator {
        uint256 id;
        address account;
        bool active;
    }

    mapping(uint256 => Validator) public validators;
    uint256 public totalValidators;

    event ValidatorRegistered(uint256 indexed id, address account, bool active);

    modifier onlyContractor() {
        require(msg.sender == sovereignContractor, "Error: Only Sovereign Contractor access.");
        _;
    }

    constructor() {
        sovereignContractor = msg.sender;
    }

    function registerValidator(address _account) public onlyContractor returns (uint256) {
        totalValidators++;
        validators[totalValidators] = Validator(totalValidators, _account, true);
        emit ValidatorRegistered(totalValidators, _account, true);
        return totalValidators;
    }

    function getValidator(uint256 id) public view returns (Validator memory) {
        return validators[id];
    }
}
