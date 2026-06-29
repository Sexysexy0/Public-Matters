// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ChildProtectionShield
/// @notice Covenant contract to safeguard communities through systemic anchoring of child protection safeguards
contract ChildProtectionShield {
    address public overseer;
    uint256 public protectionCount;

    struct ProtectionEntry {
        uint256 id;
        string child;
        string guardian;
        string safeguard;
        uint256 timestamp;
    }

    mapping(uint256 => ProtectionEntry) public protections;

    event ProtectionLogged(uint256 indexed id, string child, string guardian, string safeguard);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logProtection(
        string calldata child,
        string calldata guardian,
        string calldata safeguard
    ) external onlyOverseer {
        protectionCount++;
        protections[protectionCount] = ProtectionEntry({
            id: protectionCount,
            child: child,
            guardian: guardian,
            safeguard: safeguard,
            timestamp: block.timestamp
        });
        emit ProtectionLogged(protectionCount, child, guardian, safeguard);
    }

    function viewProtection(uint256 id) external view returns (ProtectionEntry memory) {
        return protections[id];
    }
}
