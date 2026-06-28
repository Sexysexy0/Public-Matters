// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title JusticeLedger
/// @notice Covenant contract to safeguard communities through recording truth‑anchored justice acts
contract JusticeLedger {
    address public overseer;
    uint256 public justiceCount;

    struct JusticeEntry {
        uint256 id;
        string actor;
        string context;
        string principle;
        uint256 timestamp;
    }

    mapping(uint256 => JusticeEntry) public justices;

    event JusticeLogged(uint256 indexed id, string actor, string context);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logJustice(
        string calldata actor,
        string calldata context,
        string calldata principle
    ) external onlyOverseer {
        justiceCount++;
        justices[justiceCount] = JusticeEntry({
            id: justiceCount,
            actor: actor,
            context: context,
            principle: principle,
            timestamp: block.timestamp
        });
        emit JusticeLogged(justiceCount, actor, context);
    }

    function viewJustice(uint256 id) external view returns (JusticeEntry memory) {
        return justices[id];
    }
}
