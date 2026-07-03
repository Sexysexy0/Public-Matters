// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title EqualityCodex
/// @notice Covenant contract to safeguard communities through systemic anchoring of equality principles
contract EqualityCodex {
    address public overseer;
    uint256 public equalityCount;

    struct EqualityEntry {
        uint256 id;
        string actor;
        string context;
        string principle;
        uint256 timestamp;
    }

    mapping(uint256 => EqualityEntry) public equalities;

    event EqualityLogged(uint256 indexed id, string actor, string context);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logEquality(
        string calldata actor,
        string calldata context,
        string calldata principle
    ) external onlyOverseer {
        equalityCount++;
        equalities[equalityCount] = EqualityEntry({
            id: equalityCount,
            actor: actor,
            context: context,
            principle: principle,
            timestamp: block.timestamp
        });
        emit EqualityLogged(equalityCount, actor, context);
    }

    function viewEquality(uint256 id) external view returns (EqualityEntry memory) {
        return equalities[id];
    }
}
