// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ValidatorRegistry
/// @notice Covenant contract to register and manage validators with stake
contract ValidatorRegistry {
    address public sovereignContractor;

    struct Validator {
        uint256 stake;
        bool active;
    }

    mapping(address => Validator) public validators;

    event ValidatorRegistered(address indexed account, uint256 stake, bool active);

    modifier onlyContractor() {
        require(msg.sender == sovereignContractor, "Error: Only Sovereign Contractor access.");
        _;
    }

    constructor() {
        sovereignContractor = msg.sender;
    }

    /// @notice Register a new validator with stake
    function registerValidator(uint256 _stake) public returns (bool) {
        validators[msg.sender] = Validator(_stake, true);
        emit ValidatorRegistered(msg.sender, _stake, true);
        return true;
    }

    /// @notice Fetch validator details
    function getValidator(address account) public view returns (Validator memory) {
        return validators[account];
    }
}
