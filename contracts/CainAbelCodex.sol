// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title CainAbelCodex
/// @notice Covenant contract to safeguard communities through sacrifice, integrity, and truth
contract CainAbelCodex {
    address public overseer;
    uint256 public entryCount;

    struct CodexEntry {
        uint256 id;
        string actor;
        string offering;
        string reference;
        uint256 timestamp;
    }

    mapping(uint256 => CodexEntry) public entries;

    event CodexLogged(uint256 indexed id, string actor, string offering);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logEntry(
        string calldata actor,
        string calldata offering,
        string calldata reference
    ) external onlyOverseer {
        entryCount++;
        entries[entryCount] = CodexEntry({
            id: entryCount,
            actor: actor,
            offering: offering,
            reference: reference,
            timestamp: block.timestamp
        });
        emit CodexLogged(entryCount, actor, offering);
    }

    function viewEntry(uint256 id) external view returns (CodexEntry memory) {
        return entries[id];
    }
}
