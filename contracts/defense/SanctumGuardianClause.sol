// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title SanctumGuardianClause
/// @notice Ritual-grade clause for housing sanctum protection and ancestral co-authorship
contract SanctumGuardianClause {
    address public steward;
    mapping(address => bool) public sanctumGuardians;
    mapping(address => string) public sanctumLocation;

    event GuardianActivated(address indexed guardian, string sanctum);
    event GuardianRevoked(address indexed guardian);
    event SanctumProtected(address indexed guardian, string sanctum);

    modifier onlySteward() {
        require(msg.sender == steward, "Not authorized");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function activateGuardian(address _guardian, string memory _location) public onlySteward {
        sanctumGuardians[_guardian] = true;
        sanctumLocation[_guardian] = _location;
        emit GuardianActivated(_guardian, _location);
    }

    function revokeGuardian(address _guardian) public onlySteward {
        sanctumGuardians[_guardian] = false;
        emit GuardianRevoked(_guardian);
    }

    function protectSanctum(address _guardian) public view returns (string memory) {
        require(sanctumGuardians[_guardian], "Guardian not active");
        return sanctumLocation[_guardian];
    }
}
