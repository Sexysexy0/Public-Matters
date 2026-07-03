// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title AccountabilityChainCodex
/// @notice Covenant contract to safeguard responsibility through chain of accountability in incident handling
contract AccountabilityChainCodex {
    address public overseer;
    uint256 public chainCount;

    struct ChainEntry {
        uint256 id;
        string incident;
        string responsibleParty;
        string duty;
        uint256 timestamp;
    }

    mapping(uint256 => ChainEntry) public chains;

    event ChainLogged(uint256 indexed id, string incident, string responsibleParty);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logChain(
        string calldata incident,
        string calldata responsibleParty,
        string calldata duty
    ) external onlyOverseer {
        chainCount++;
        chains[chainCount] = ChainEntry({
            id: chainCount,
            incident: incident,
            responsibleParty: responsibleParty,
            duty: duty,
            timestamp: block.timestamp
        });
        emit ChainLogged(chainCount, incident, responsibleParty);
    }

    function viewChain(uint256 id) external view returns (ChainEntry memory) {
        return chains[id];
    }
}
