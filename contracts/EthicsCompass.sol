// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title EthicsCompass
/// @notice Covenant to safeguard ethical compass,
///         ensuring moral guidance, fairness, and dignified decision-making.
contract EthicsCompass {
    address public overseer;
    uint256 public compassCount;

    struct Compass {
        uint256 id;
        string principle;   // MoralGuidance, Fairness, Dignity
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => Compass) public compasses;

    event CompassDeclared(uint256 indexed id, string principle, string description);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function declareCompass(string calldata principle, string calldata description) external onlyOverseer {
        compassCount++;
        compasses[compassCount] = Compass(compassCount, principle, description, block.timestamp);
        emit CompassDeclared(compassCount, principle, description);
    }

    function viewCompass(uint256 id) external view returns (Compass memory) {
        return compasses[id];
    }
}
