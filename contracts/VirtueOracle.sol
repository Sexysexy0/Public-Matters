// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title VirtueOracle
/// @notice Covenant contract to safeguard portfolios through systemic anchoring of virtue safeguards
contract VirtueOracle {
    address public overseer;
    uint256 public virtueCount;

    struct VirtueRule {
        uint256 id;
        string principle; // Courage, Temperance, Justice, Wisdom
        uint256 threshold; // safeguard value
        uint256 timestamp;
    }

    mapping(uint256 => VirtueRule) public virtues;

    event VirtueLogged(uint256 indexed id, string principle, uint256 threshold);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logVirtue(
        string calldata principle,
        uint256 threshold
    ) external onlyOverseer {
        virtueCount++;
        virtues[virtueCount] = VirtueRule({
            id: virtueCount,
            principle: principle,
            threshold: threshold,
            timestamp: block.timestamp
        });
        emit VirtueLogged(virtueCount, principle, threshold);
    }

    function viewVirtue(uint256 id) external view returns (VirtueRule memory) {
        return virtues[id];
    }
}
