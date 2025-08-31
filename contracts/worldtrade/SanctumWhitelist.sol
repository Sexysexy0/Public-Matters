// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.19;

/// @title SanctumWhitelist
/// @author Vinvin
/// @notice Whitelists trusted sanctums, mod forks, and sovereign builds

contract SanctumWhitelist {
    mapping(string => bool) public sanctumApproved;
    string[] public approvedSanctums;

    event SanctumWhitelisted(string name);
    event SanctumRevoked(string name);

    /// @notice Whitelist a sanctum
    function whitelistSanctum(string memory _name) public {
        require(!sanctumApproved[_name], "Already whitelisted");
        sanctumApproved[_name] = true;
        approvedSanctums.push(_name);
        emit SanctumWhitelisted(_name);
    }

    /// @notice Revoke a sanctum
    function revokeSanctum(string memory _name) public {
        require(sanctumApproved[_name], "Sanctum not whitelisted");
        sanctumApproved[_name] = false;
        emit SanctumRevoked(_name);
    }

    /// @notice Check if sanctum is approved
    function isApproved(string memory _name) public view returns (bool) {
        return sanctumApproved[_name];
    }

    /// @notice Get all approved sanctums
    function getApprovedSanctums() public view returns (string[] memory) {
        return approvedSanctums;
    }
}
