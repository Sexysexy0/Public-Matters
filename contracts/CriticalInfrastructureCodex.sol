// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CriticalInfrastructureCodex {
    address public overseer;
    uint256 public safeguardCount;

    struct Safeguard {
        uint256 id;
        string sector;   // Energy, Transport, Health
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => Safeguard) public safeguards;
    event SafeguardDeclared(uint256 indexed id, string sector, string description);

    constructor(address _overseer) {
        overseer = _overseer;
    }

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    function declareSafeguard(string calldata sector, string calldata description) external onlyOverseer {
        safeguardCount++;
        safeguards[safeguardCount] = Safeguard(safeguardCount, sector, description, block.timestamp);
        emit SafeguardDeclared(safeguardCount, sector, description);
    }
}
