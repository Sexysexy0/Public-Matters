// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title TruthWitnessCodex
/// @notice Covenant contract to safeguard communities through authenticity and witness of truth
contract TruthWitnessCodex {
    address public overseer;
    uint256 public witnessCount;

    struct WitnessEntry {
        uint256 id;
        string declarant;
        string statement;
        string reference;
        uint256 timestamp;
    }

    mapping(uint256 => WitnessEntry) public witnesses;

    event WitnessLogged(uint256 indexed id, string declarant, string statement);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logWitness(
        string calldata declarant,
        string calldata statement,
        string calldata reference
    ) external onlyOverseer {
        witnessCount++;
        witnesses[witnessCount] = WitnessEntry({
            id: witnessCount,
            declarant: declarant,
            statement: statement,
            reference: reference,
            timestamp: block.timestamp
        });
        emit WitnessLogged(witnessCount, declarant, statement);
    }

    function viewWitness(uint256 id) external view returns (WitnessEntry memory) {
        return witnesses[id];
    }
}
