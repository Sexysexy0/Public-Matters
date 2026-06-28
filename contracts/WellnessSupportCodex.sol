// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title WellnessSupportCodex
/// @notice Covenant contract to safeguard students through counseling and wellness programs
contract WellnessSupportCodex {
    address public overseer;
    uint256 public wellnessCount;

    struct WellnessEntry {
        uint256 id;
        string program;
        string beneficiary;
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => WellnessEntry) public wellnessEntries;

    event WellnessLogged(uint256 indexed id, string program, string beneficiary);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logWellness(
        string calldata program,
        string calldata beneficiary,
        string calldata description
    ) external onlyOverseer {
        wellnessCount++;
        wellnessEntries[wellnessCount] = WellnessEntry({
            id: wellnessCount,
            program: program,
            beneficiary: beneficiary,
            description: description,
            timestamp: block.timestamp
        });
        emit WellnessLogged(wellnessCount, program, beneficiary);
    }

    function viewWellness(uint256 id) external view returns (WellnessEntry memory) {
        return wellnessEntries[id];
    }
}
