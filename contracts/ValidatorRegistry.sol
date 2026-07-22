// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ValidatorRegistry {
    struct Validator {
        address account;
        uint256 stake;
        uint256 reputation;
        bool active;
    }

    mapping(address => Validator) public validators;

    event ValidatorRegistered(address indexed account, uint256 stake);
    event ValidatorSlashed(address indexed account, uint256 amount, string reason);
    event ReputationUpdated(address indexed account, uint256 newReputation);

    function registerValidator(uint256 stake) external {
        require(validators[msg.sender].account == address(0), "Already registered");
        validators[msg.sender] = Validator({
            account: msg.sender,
            stake: stake,
            reputation: 100, // default reputation
            active: true
        });
        emit ValidatorRegistered(msg.sender, stake);
    }

    function slashValidator(address account, uint256 amount, string calldata reason) external {
        require(validators[account].active, "Validator not active");
        require(validators[account].stake >= amount, "Insufficient stake");
        validators[account].stake -= amount;
        emit ValidatorSlashed(account, amount, reason);
    }

    function updateReputation(address account, uint256 delta, bool increase) external {
        require(validators[account].active, "Validator not active");
        if (increase) {
            validators[account].reputation += delta;
        } else {
            validators[account].reputation -= delta;
        }
        emit ReputationUpdated(account, validators[account].reputation);
    }

    // ✅ Helper functions para hindi ka magka-error sa tuple access
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
