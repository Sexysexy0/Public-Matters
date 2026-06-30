// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract HotfixCodex {
    address public overseer;
    uint256 public hotfixCount;

    struct HotfixRule {
        uint256 id;
        string principle; // Rapid Response, Stability, Minimal Disruption, Verification
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => HotfixRule) public hotfixes;

    event HotfixLogged(uint256 indexed id, string principle, string description);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logHotfix(
        string calldata principle,
        string calldata description
    ) external onlyOverseer {
        hotfixCount++;
        hotfixes[hotfixCount] = HotfixRule({
            id: hotfixCount,
            principle: principle,
            description: description,
            timestamp: block.timestamp
        });
        emit HotfixLogged(hotfixCount, principle, description);
    }

    function viewHotfix(uint256 id) external view returns (HotfixRule memory) {
        return hotfixes[id];
    }
}
