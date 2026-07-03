// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title WellnessSupportCodex
/// @notice Covenant contract to safeguard communities through emotional and psychological wellness support
contract WellnessSupportCodex {
    address public overseer;
    uint256 public wellnessCount;

    struct WellnessEntry {
        uint256 id;
        string beneficiary;
        string program;
        string facilitator;
        uint256 timestamp;
    }

    mapping(uint256 => WellnessEntry) public wellnessEntries;

    event WellnessLogged(uint256 indexed id, string beneficiary, string program);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logWellness(
        string calldata beneficiary,
        string calldata program,
        string calldata facilitator
    ) external onlyOverseer {
        wellnessCount++;
        wellnessEntries[wellnessCount] = WellnessEntry({
            id: wellnessCount,
            beneficiary: beneficiary,
            program: program,
            facilitator: facilitator,
            timestamp: block.timestamp
        });
        emit WellnessLogged(wellnessCount, beneficiary, program);
    }

    function viewWellness(uint256 id) external view returns (WellnessEntry memory) {
        return wellnessEntries[id];
    }
}
