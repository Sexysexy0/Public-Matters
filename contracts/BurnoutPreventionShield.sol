// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title BurnoutPreventionShield
/// @notice Covenant contract to safeguard communities through systemic anchoring of burnout prevention safeguards
contract BurnoutPreventionShield {
    address public overseer;
    uint256 public burnoutCount;

    struct BurnoutEntry {
        uint256 id;
        string actor;
        string context;
        string principle;
        uint256 timestamp;
    }

    mapping(uint256 => BurnoutEntry) public burnouts;

    event BurnoutLogged(uint256 indexed id, string actor, string context);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logBurnout(
        string calldata actor,
        string calldata context,
        string calldata principle
    ) external onlyOverseer {
        burnoutCount++;
        burnouts[burnoutCount] = BurnoutEntry({
            id: burnoutCount,
            actor: actor,
            context: context,
            principle: principle,
            timestamp: block.timestamp
        });
        emit BurnoutLogged(burnoutCount, actor, context);
    }

    function viewBurnout(uint256 id) external view returns (BurnoutEntry memory) {
        return burnouts[id];
    }
}
