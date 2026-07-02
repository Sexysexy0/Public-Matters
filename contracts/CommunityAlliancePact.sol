// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CommunityAlliancePact {
    address public overseer;
    uint256 public pactCount;

    struct Pact {
        uint256 id;
        string domain;   // Guilds, Networks, Alliances
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => Pact) public pacts;
    event PactSigned(uint256 indexed id, string domain, string description);

    constructor(address _overseer) {
        overseer = _overseer;
    }

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    function signPact(string calldata domain, string calldata description) external onlyOverseer {
        pactCount++;
        pacts[pactCount] = Pact(pactCount, domain, description, block.timestamp);
        emit PactSigned(pactCount, domain, description);
    }
}
