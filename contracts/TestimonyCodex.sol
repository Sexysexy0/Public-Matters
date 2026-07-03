// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title TestimonyCodex
/// @notice Covenant contract to symbolically safeguard collective testimonies, existential resilience, and liberty-driven awakening
contract TestimonyCodex {
    address public overseer;
    uint256 public testimonyCount;

    struct TestimonyRule {
        uint256 id;
        string principle; // Nostalgia, Awakening, Liberty vs Safety, Existential Resilience
        string description; // encoded testimony safeguard
        uint256 timestamp;
    }

    mapping(uint256 => TestimonyRule) public testimonies;

    event TestimonyLogged(uint256 indexed id, string principle, string description);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logTestimony(
        string calldata principle,
        string calldata description
    ) external onlyOverseer {
        testimonyCount++;
        testimonies[testimonyCount] = TestimonyRule({
            id: testimonyCount,
            principle: principle,
            description: description,
            timestamp: block.timestamp
        });
        emit TestimonyLogged(testimonyCount, principle, description);
    }

    function viewTestimony(uint256 id) external view returns (TestimonyRule memory) {
        return testimonies[id];
    }
}
