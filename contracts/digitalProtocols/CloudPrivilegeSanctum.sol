// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract CloudPrivilegeSanctum {
    mapping(address => bool) public isElevated;
    address public steward;

    modifier onlySteward() {
        require(msg.sender == steward, "Not authorized");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function requestElevation(address user) public onlySteward {
        require(!isElevated[user], "Already elevated");
        isElevated[user] = true;
    }

    function revokeElevation(address user) public onlySteward {
        require(isElevated[user], "Not elevated");
        isElevated[user] = false;
    }

    function auditElevation(address user) public view returns (bool) {
        return isElevated[user];
    }
}
