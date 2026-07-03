// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ScienceCodex
/// @notice Covenant contract to symbolically safeguard evidence-based advocacy, clinical validation, and scientific foundation
contract ScienceCodex {
    address public overseer;
    uint256 public scienceCount;

    struct ScienceRule {
        uint256 id;
        string principle; // Evidence-Based Policy, Clinical Validation, Research Foundation, Scientific Equity
        string description; // encoded science safeguard
        uint256 timestamp;
    }

    mapping(uint256 => ScienceRule) public sciences;

    event ScienceLogged(uint256 indexed id, string principle, string description);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logScience(
        string calldata principle,
        string calldata description
    ) external onlyOverseer {
        scienceCount++;
        sciences[scienceCount] = ScienceRule({
            id: scienceCount,
            principle: principle,
            description: description,
            timestamp: block.timestamp
        });
        emit ScienceLogged(scienceCount, principle, description);
    }

    function viewScience(uint256 id) external view returns (ScienceRule memory) {
        return sciences[id];
    }
}
