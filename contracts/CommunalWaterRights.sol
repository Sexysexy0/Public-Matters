// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title CommunalWaterRights
/// @notice Safeguard contract encoding communal rights to dignified water access
/// @dev Complements WaterGovernanceReversion covenant

contract CommunalWaterRights {
    address public guardian;
    mapping(address => bool) public registeredResidents;
    mapping(address => bool) public accessRevoked;
    event ResidentRegistered(address indexed resident, uint256 timestamp);
    event AccessRevoked(address indexed resident, string reason, uint256 timestamp);
    event AccessRestored(address indexed resident, uint256 timestamp);

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Not authorized");
        _;
    }

    constructor(address _guardian) {
        guardian = _guardian;
    }

    /// @notice Register a resident for communal water rights
    /// @param resident address of the resident
    function registerResident(address resident) external onlyGuardian {
        registeredResidents[resident] = true;
        emit ResidentRegistered(resident, block.timestamp);
    }

    /// @notice Revoke water access for abuse or violation
    /// @param resident address of the resident
    /// @param reason short descriptor of why revoked
    function revokeAccess(address resident, string calldata reason) external onlyGuardian {
        require(registeredResidents[resident], "Not registered");
        accessRevoked[resident] = true;
        emit AccessRevoked(resident, reason, block.timestamp);
    }

    /// @notice Restore water access after DAO/community review
    /// @param resident address of the resident
    function restoreAccess(address resident) external onlyGuardian {
        require(accessRevoked[resident], "Not revoked");
        accessRevoked[resident] = false;
        emit AccessRestored(resident, block.timestamp);
    }

    /// @notice Verify if resident has active water rights
    /// @param resident address of the resident
    /// @return true if registered and not revoked
    function hasRights(address resident) external view returns (bool) {
        return registeredResidents[resident] && !accessRevoked[resident];
    }
}
