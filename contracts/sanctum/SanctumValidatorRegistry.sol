// SPDX-License-Identifier: Mythic-Scroll
pragma solidity ^0.8.19;

contract SanctumValidatorRegistry {
    mapping(address => bool) public isValidator;
    event ValidatorAdded(address indexed validator);
    event ValidatorRemoved(address indexed validator);

    address public steward;

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized scrollcaster");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function addValidator(address validator) external onlySteward {
        isValidator[validator] = true;
        emit ValidatorAdded(validator);
    }

    function removeValidator(address validator) external onlySteward {
        isValidator[validator] = false;
        emit ValidatorRemoved(validator);
    }

    function checkValidator(address validator) external view returns (bool) {
        return isValidator[validator];
    }
}
