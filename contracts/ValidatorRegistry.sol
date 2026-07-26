// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ValidatorRegistry
/// @notice Covenant contract to register and manage validators with stake
contract ValidatorRegistry {
    address public sovereignContractor;

    struct Validator {
        uint256 stake;
        uint256 reputation;
        bool active;
    }

    mapping(address => Validator) public validators;

    event ValidatorRegistered(address indexed account, uint256 stake, bool active);
    event ValidatorSlashed(address indexed account, uint256 amount, string reason);
    event ReputationUpdated(address indexed account, uint256 newReputation);

    modifier onlyContractor() {
        require(msg.sender == sovereignContractor, "Error: Only Sovereign Contractor access.");
        _;
    }

    constructor() {
        sovereignContractor = msg.sender;
    }

    function registerValidator(uint256 _stake) public returns (bool) {
        require(!validators[msg.sender].active, "Already registered");
        validators[msg.sender] = Validator(_stake, 100, true);
        emit ValidatorRegistered(msg.sender, _stake, true);
        return true;
    }

    function slashValidator(address account, uint256 amount, string calldata reason) external onlyContractor {
        require(validators[account].active, "Validator not active");
        require(validators[account].stake >= amount, "Insufficient stake");
        validators[account].stake -= amount;
        emit ValidatorSlashed(account, amount, reason);
    }

    function updateReputation(address account, uint256 delta, bool increase) external onlyContractor {
        require(validators[account].active, "Validator not active");
        if (increase) {
            validators[account].reputation += delta;
        } else {
            validators[account].reputation -= delta;
        }
        emit ReputationUpdated(account, validators[account].reputation);
    }

    function getValidator(address account) public view returns (Validator memory) {
        return validators[account];
    }

    function getStake(address account) external view returns (uint256) {
        return validators[account].stake;
    }

    function getReputation(address account) external view returns (uint256) {
        return validators[account].reputation;
    }

    function isActive(address account) external view returns (bool) {
        return validators[account].active;
    }
}
