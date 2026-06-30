// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title OversightCodex
/// @notice Covenant contract to safeguard backend leadership, accountability, and systemic oversight
contract OversightCodex {
    address public overseer;
    uint256 public oversightCount;

    struct OversightRule {
        uint256 id;
        string principle; // Backend Leadership, Accountability, Strategic Thinking, Governance Oversight
        string description; // encoded oversight safeguard
        uint256 timestamp;
    }

    mapping(uint256 => OversightRule) public oversight;

    event OversightLogged(uint256 indexed id, string principle, string description);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logOversight(
        string calldata principle,
        string calldata description
    ) external onlyOverseer {
        oversightCount++;
        oversight[oversightCount] = OversightRule({
            id: oversightCount,
            principle: principle,
            description: description,
            timestamp: block.timestamp
        });
        emit OversightLogged(oversightCount, principle, description);
    }

    function viewOversight(uint256 id) external view returns (OversightRule memory) {
        return oversight[id];
    }
}
