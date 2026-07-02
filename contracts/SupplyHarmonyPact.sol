// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SupplyHarmonyPact {
    address public overseer;
    uint256 public pactCount;

    struct Pact {
        uint256 id;
        string sector;   // Producer, Distributor, Consumer
        string agreement;
        uint256 timestamp;
    }

    mapping(uint256 => Pact) public pacts;
    event PactSigned(uint256 indexed id, string sector, string agreement);

    constructor(address _overseer) {
        overseer = _overseer;
    }

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    function signPact(string calldata sector, string calldata agreement) external onlyOverseer {
        pactCount++;
        pacts[pactCount] = Pact(pactCount, sector, agreement, block.timestamp);
        emit PactSigned(pactCount, sector, agreement);
    }
}
