// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract OpenSourceAccessRevocation {
    address public steward = msg.sender;

    struct Nation {
        string name;
        bool accessRevoked;
        uint256 timestamp;
    }

    mapping(string => Nation) public revocations;

    event AccessRevoked(string nation, string reason, uint256 timestamp);

    function revokeAccess(string memory nation, string memory reason) public {
        revocations[nation] = Nation(nation, true, block.timestamp);
        emit AccessRevoked(nation, reason, block.timestamp);
    }

    function isRevoked(string memory nation) public view returns (bool) {
        return revocations[nation].accessRevoked;
    }
}
