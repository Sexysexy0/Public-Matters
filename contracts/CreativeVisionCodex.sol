// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CreativeVisionCodex {
    address public overseer;
    uint256 public visionCount;

    struct VisionRule {
        uint256 id;
        string principle; // Narrative Alignment, Gameplay Identity, Franchise Continuity, Innovation
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => VisionRule) public visions;

    event VisionLogged(uint256 indexed id, string principle, string description);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logVision(
        string calldata principle,
        string calldata description
    ) external onlyOverseer {
        visionCount++;
        visions[visionCount] = VisionRule({
            id: visionCount,
            principle: principle,
            description: description,
            timestamp: block.timestamp
        });
        emit VisionLogged(visionCount, principle, description);
    }

    function viewVision(uint256 id) external view returns (VisionRule memory) {
        return visions[id];
    }
}
