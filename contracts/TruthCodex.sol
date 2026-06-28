// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title TruthCodex
/// @notice Covenant contract to safeguard communities through systemic anchoring of truth against deception
contract TruthCodex {
    address public overseer;
    uint256 public truthCount;

    struct TruthEntry {
        uint256 id;
        string actor;
        string context;
        string principle;
        uint256 timestamp;
    }

    mapping(uint256 => TruthEntry) public truths;

    event TruthLogged(uint256 indexed id, string actor, string context);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logTruth(
        string calldata actor,
        string calldata context,
        string calldata principle
    ) external onlyOverseer {
        truthCount++;
        truths[truthCount] = TruthEntry({
            id: truthCount,
            actor: actor,
            context: context,
            principle: principle,
            timestamp: block.timestamp
        });
        emit TruthLogged(truthCount, actor, context);
    }

    function viewTruth(uint256 id) external view returns (TruthEntry memory) {
        return truths[id];
    }
}
