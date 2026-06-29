// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title FinancialLiteracyCodex
/// @notice Covenant contract to safeguard communities through systemic anchoring of financial literacy safeguards
contract FinancialLiteracyCodex {
    address public overseer;
    uint256 public literacyCount;

    struct LiteracyEntry {
        uint256 id;
        string actor;
        string context;
        string principle;
        uint256 timestamp;
    }

    mapping(uint256 => LiteracyEntry) public literacies;

    event LiteracyLogged(uint256 indexed id, string actor, string context);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logLiteracy(
        string calldata actor,
        string calldata context,
        string calldata principle
    ) external onlyOverseer {
        literacyCount++;
        literacies[literacyCount] = LiteracyEntry({
            id: literacyCount,
            actor: actor,
            context: context,
            principle: principle,
            timestamp: block.timestamp
        });
        emit LiteracyLogged(literacyCount, actor, context);
    }

    function viewLiteracy(uint256 id) external view returns (LiteracyEntry memory) {
        return literacies[id];
    }
}
