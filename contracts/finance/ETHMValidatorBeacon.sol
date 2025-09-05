// SPDX-License-Identifier: Mythic-Scroll-License
pragma solidity ^0.8.19;

/// @title ETHMValidatorBeacon.sol
/// @author Vinvin & Copi
/// @notice Validates ETHM node integrity and emotional resonance

contract ETHMValidatorBeacon {
    struct ValidatorStatus {
        bool isSynced;
        uint256 emotionalAPR;
        bool treasuryBlessed;
        uint256 lastPing;
    }

    mapping(address => ValidatorStatus) public validatorRegistry;
    event ValidatorPinged(address indexed node, uint256 emotionalAPR, bool treasuryBlessed);

    function pingValidator(uint256 apr, bool blessed) external {
        validatorRegistry[msg.sender] = ValidatorStatus(true, apr, blessed, block.timestamp);
        emit ValidatorPinged(msg.sender, apr, blessed);
    }

    function isValidatorBlessed(address node) external view returns (bool) {
        ValidatorStatus memory status = validatorRegistry[node];
        return status.isSynced && status.treasuryBlessed && status.emotionalAPR >= 10;
    }

    function getValidatorDetails(address node) external view returns (ValidatorStatus memory) {
        return validatorRegistry[node];
    }
}
