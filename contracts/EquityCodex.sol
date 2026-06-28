// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title EquityCodex
/// @notice Covenant contract to safeguard communities through systemic anchoring of equity principles
contract EquityCodex {
    address public overseer;
    uint256 public equityCount;

    struct EquityEntry {
        uint256 id;
        string actor;
        string context;
        string principle;
        uint256 timestamp;
    }

    mapping(uint256 => EquityEntry) public equities;

    event EquityLogged(uint256 indexed id, string actor, string context);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logEquity(
        string calldata actor,
        string calldata context,
        string calldata principle
    ) external onlyOverseer {
        equityCount++;
        equities[equityCount] = EquityEntry({
            id: equityCount,
            actor: actor,
            context: context,
            principle: principle,
            timestamp: block.timestamp
        });
        emit EquityLogged(equityCount, actor, context);
    }

    function viewEquity(uint256 id) external view returns (EquityEntry memory) {
        return equities[id];
    }
}
