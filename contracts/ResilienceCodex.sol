// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ResilienceCodex
/// @notice Covenant contract to safeguard communities through systemic anchoring of resilience against exhaustion
contract ResilienceCodex {
    address public overseer;
    uint256 public resilienceCount;

    struct ResilienceEntry {
        uint256 id;
        string actor;
        string challenge;
        string method;
        uint256 timestamp;
    }

    mapping(uint256 => ResilienceEntry) public resiliences;

    event ResilienceLogged(uint256 indexed id, string actor, string method);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logResilience(
        string calldata actor,
        string calldata challenge,
        string calldata method
    ) external onlyOverseer {
        resilienceCount++;
        resiliences[resilienceCount] = ResilienceEntry({
            id: resilienceCount,
            actor: actor,
            challenge: challenge,
            method: method,
            timestamp: block.timestamp
        });
        emit ResilienceLogged(resilienceCount, actor, method);
    }

    function viewResilience(uint256 id) external view returns (ResilienceEntry memory) {
        return resiliences[id];
    }
}
