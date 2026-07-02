// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title GuardianPledge
/// @notice Covenant contract to safeguard protection of people and nature,
///         ensuring safety, stewardship, and dignity for all.
contract GuardianPledge {
    address public overseer;
    uint256 public pledgeCount;

    struct Pledge {
        uint256 id;
        string principle;   // Protection, Stewardship, Safety, Dignity
        string description; // Encoded safeguard
        uint256 timestamp;
    }

    mapping(uint256 => Pledge) public pledges;

    event PledgeDeclared(uint256 indexed id, string principle, string description);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function declarePledge(
        string calldata principle,
        string calldata description
    ) external onlyOverseer {
        pledgeCount++;
        pledges[pledgeCount] = Pledge({
            id: pledgeCount,
            principle: principle,
            description: description,
            timestamp: block.timestamp
        });
        emit PledgeDeclared(pledgeCount, principle, description);
    }

    function viewPledge(uint256 id) external view returns (Pledge memory) {
        return pledges[id];
    }
}
