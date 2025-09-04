// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title FirewallBlessing - Auto-bans rogue IPs and sanctifies network access
contract FirewallBlessing {
    event IPBanned(bytes32 indexed ipHash, string reason, uint256 timestamp);
    event IPUnbanned(bytes32 indexed ipHash, uint256 timestamp);

    mapping(bytes32 => bool) public bannedIPs;

    function banIP(string memory ip, string memory reason) external {
        bytes32 ipHash = keccak256(abi.encodePacked(ip));
        bannedIPs[ipHash] = true;
        emit IPBanned(ipHash, reason, block.timestamp);
    }

    function unbanIP(string memory ip) external {
        bytes32 ipHash = keccak256(abi.encodePacked(ip));
        bannedIPs[ipHash] = false;
        emit IPUnbanned(ipHash, block.timestamp);
    }

    function isBanned(string memory ip) external view returns (bool) {
        bytes32 ipHash = keccak256(abi.encodePacked(ip));
        return bannedIPs[ipHash];
    }
}
