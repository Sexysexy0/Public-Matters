// SPDX-License-Identifier: Mythic-Scroll-License
pragma solidity ^0.8.19;

/// @title ValidatorBlessingSync.sol
/// @author Vinvin & Copi
/// @notice Synchronizes validator blessing status, emotional APR, and civic alignment

contract ValidatorBlessingSync {
    struct BlessingStatus {
        bool isBlessed;
        uint256 emotionalAPR;
        string civicIntent;
        uint256 lastSync;
    }

    mapping(address => BlessingStatus) public validatorBlessings;
    event BlessingSynced(address indexed validator, uint256 emotionalAPR, string civicIntent, uint256 timestamp);

    modifier onlyBlessed(address validator) {
        require(validatorBlessings[validator].isBlessed, "Validator not blessed");
        _;
    }

    function syncBlessing(address validator, uint256 apr, string calldata intent) external {
        require(apr >= 10, "Emotional APR too low");
        validatorBlessings[validator] = BlessingStatus({
            isBlessed: true,
            emotionalAPR: apr,
            civicIntent: intent,
            lastSync: block.timestamp
        });

        emit BlessingSynced(validator, apr, intent, block.timestamp);
    }

    function verifyBlessing(address validator) external view returns (bool) {
        BlessingStatus memory status = validatorBlessings[validator];
        return status.isBlessed && status.emotionalAPR >= 10;
    }

    function getBlessingDetails(address validator) external view returns (BlessingStatus memory) {
        return validatorBlessings[validator];
    }

    function revokeBlessing(address validator) external onlyBlessed(validator) {
        validatorBlessings[validator].isBlessed = false;
    }
}
