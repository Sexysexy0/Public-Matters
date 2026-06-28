// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title JusticeCodex
/// @notice Covenant contract to safeguard communities through systemic anchoring of justice principles
contract JusticeCodex {
    address public overseer;
    uint256 public justiceCount;

    struct JusticeEntry {
        uint256 id;
        string actor;
        string domain;
        string principle;
        uint256 timestamp;
    }

    mapping(uint256 => JusticeEntry) public justices;

    event JusticeLogged(uint256 indexed id, string actor, string domain);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logJustice(
        string calldata actor,
        string calldata domain,
        string calldata principle
    ) external onlyOverseer {
        justiceCount++;
        justices[justiceCount] = JusticeEntry({
            id: justiceCount,
            actor: actor,
            domain: domain,
            principle: principle,
            timestamp: block.timestamp
        });
        emit JusticeLogged(justiceCount, actor, domain);
    }

    function viewJustice(uint256 id) external view returns (JusticeEntry memory) {
        return justices[id];
    }
}
