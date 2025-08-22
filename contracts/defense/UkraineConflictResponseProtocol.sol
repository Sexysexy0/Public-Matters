// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title UkraineConflictResponseProtocol
/// @dev Grants conditional executive rights based on verified infrastructure sabotage

contract UkraineConflictResponseProtocol {
    address public executiveAuthority;
    bool public rightsGranted;
    string public justification;
    uint256 public activationTimestamp;

    event RightsGranted(address indexed authority, string reason, uint256 timestamp);
    event RightsRevoked(address indexed authority, uint256 timestamp);

    constructor(address _executiveAuthority) {
        executiveAuthority = _executiveAuthority;
        rightsGranted = false;
    }

    function grantRights(string memory reason) external {
        require(!rightsGranted, "Rights already granted");
        justification = reason;
        rightsGranted = true;
        activationTimestamp = block.timestamp;
        emit RightsGranted(executiveAuthority, reason, activationTimestamp);
    }

    function revokeRights() external {
        require(rightsGranted, "No rights to revoke");
        rightsGranted = false;
        emit RightsRevoked(executiveAuthority, block.timestamp);
    }

    function getStatus() external view returns (string memory status) {
        if (rightsGranted) {
            return "Executive action authorized";
        } else {
            return "No active authorization";
        }
    }
}
