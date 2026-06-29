// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title StressManagementShield
/// @notice Covenant contract to safeguard communities through systemic anchoring of stress management safeguards
contract StressManagementShield {
    address public overseer;
    uint256 public stressCount;

    struct StressEntry {
        uint256 id;
        string actor;
        string context;
        string principle;
        uint256 timestamp;
    }

    mapping(uint256 => StressEntry) public stresses;

    event StressLogged(uint256 indexed id, string actor, string context);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logStress(
        string calldata actor,
        string calldata context,
        string calldata principle
    ) external onlyOverseer {
        stressCount++;
        stresses[stressCount] = StressEntry({
            id: stressCount,
            actor: actor,
            context: context,
            principle: principle,
            timestamp: block.timestamp
        });
        emit StressLogged(stressCount, actor, context);
    }

    function viewStress(uint256 id) external view returns (StressEntry memory) {
        return stresses[id];
    }
}
