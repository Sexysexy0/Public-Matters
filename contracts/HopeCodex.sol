// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title HopeCodex
/// @notice Covenant contract to safeguard communities through systemic anchoring of hope against despair
contract HopeCodex {
    address public overseer;
    uint256 public hopeCount;

    struct HopeEntry {
        uint256 id;
        string actor;
        string context;
        string principle;
        uint256 timestamp;
    }

    mapping(uint256 => HopeEntry) public hopes;

    event HopeLogged(uint256 indexed id, string actor, string context);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logHope(
        string calldata actor,
        string calldata context,
        string calldata principle
    ) external onlyOverseer {
        hopeCount++;
        hopes[hopeCount] = HopeEntry({
            id: hopeCount,
            actor: actor,
            context: context,
            principle: principle,
            timestamp: block.timestamp
        });
        emit HopeLogged(hopeCount, actor, context);
    }

    function viewHope(uint256 id) external view returns (HopeEntry memory) {
        return hopes[id];
    }
}
