// SPDX-License-Identifier: Mythic-Scroll-License
pragma solidity ^0.8.19;

/// @title ValidatorSyncOracle.sol
/// @author Vinvin & Copi
/// @notice Verifies validator sync status and emotional resonance

contract ValidatorSyncOracle {
    struct SyncStatus {
        bool isSynced;
        uint256 emotionalAPR;
        bool civicBlessed;
        uint256 lastSync;
    }

    mapping(address => SyncStatus) public validatorSync;
    event SyncVerified(address indexed validator, uint256 emotionalAPR, bool civicBlessed, uint256 timestamp);

    function verifySync(uint256 apr, bool blessed) external {
        require(apr >= 10, "Emotional APR too low");
        validatorSync[msg.sender] = SyncStatus(true, apr, blessed, block.timestamp);
        emit SyncVerified(msg.sender, apr, blessed, block.timestamp);
    }

    function isSynced(address validator) external view returns (bool) {
        SyncStatus memory status = validatorSync[validator];
        return status.isSynced && status.civicBlessed && status.emotionalAPR >= 10;
    }

    function getSyncDetails(address validator) external view returns (SyncStatus memory) {
        return validatorSync[validator];
    }
}
