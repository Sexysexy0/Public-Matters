// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title SacredCodex
/// @notice Covenant contract to safeguard communities through systemic anchoring of sacred values
contract SacredCodex {
    address public overseer;
    uint256 public sacredCount;

    struct SacredEntry {
        uint256 id;
        string actor;
        string context;
        string principle;
        uint256 timestamp;
    }

    mapping(uint256 => SacredEntry) public sacreds;

    event SacredLogged(uint256 indexed id, string actor, string context);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logSacred(
        string calldata actor,
        string calldata context,
        string calldata principle
    ) external onlyOverseer {
        sacredCount++;
        sacreds[sacredCount] = SacredEntry({
            id: sacredCount,
            actor: actor,
            context: context,
            principle: principle,
            timestamp: block.timestamp
        });
        emit SacredLogged(sacredCount, actor, context);
    }

    function viewSacred(uint256 id) external view returns (SacredEntry memory) {
        return sacreds[id];
    }
}
