// SPDX-License-Identifier: Mythic-Protocol
pragma solidity ^0.8.19;

contract EmployerBlessingProtocol {
    address public steward;
    mapping(address => bool) public blessedEmployers;
    mapping(address => bool) public revokedEmployers;

    event EmployerBlessed(address employer, uint256 timestamp);
    event EmployerRevoked(address employer, uint256 timestamp);

    constructor() {
        steward = msg.sender;
    }

    function blessEmployer(address employer) public {
        require(msg.sender == steward, "Only steward may bless.");
        blessedEmployers[employer] = true;
        revokedEmployers[employer] = false;
        emit EmployerBlessed(employer, block.timestamp);
    }

    function revokeEmployer(address employer) public {
        require(msg.sender == steward, "Only steward may revoke.");
        blessedEmployers[employer] = false;
        revokedEmployers[employer] = true;
        emit EmployerRevoked(employer, block.timestamp);
    }

    function isBlessed(address employer) public view returns (bool) {
        return blessedEmployers[employer];
    }

    function isRevoked(address employer) public view returns (bool) {
        return revokedEmployers[employer];
    }
}
