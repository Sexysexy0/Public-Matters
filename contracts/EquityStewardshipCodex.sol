// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title EquityStewardshipCodex
/// @notice Covenant contract to safeguard communities through fairness and stewardship of equity systems
contract EquityStewardshipCodex {
    address public overseer;
    uint256 public equityCount;

    struct EquityEntry {
        uint256 id;
        string actor;
        string domain;
        string method;
        uint256 timestamp;
    }

    mapping(uint256 => EquityEntry) public equities;

    event EquityLogged(uint256 indexed id, string actor, string domain);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logEquity(
        string calldata actor,
        string calldata domain,
        string calldata method
    ) external onlyOverseer {
        equityCount++;
        equities[equityCount] = EquityEntry({
            id: equityCount,
            actor: actor,
            domain: domain,
            method: method,
            timestamp: block.timestamp
        });
        emit EquityLogged(equityCount, actor, domain);
    }

    function viewEquity(uint256 id) external view returns (EquityEntry memory) {
        return equities[id];
    }
}
