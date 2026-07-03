// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract PublicTrustLedger {
    address public overseer;
    uint256 public trustCount;

    struct Trust {
        uint256 id;
        string initiative;   // Transparency, Accountability, Relief
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => Trust) public trusts;
    event TrustDeclared(uint256 indexed id, string initiative, string description);

    constructor(address _overseer) {
        overseer = _overseer;
    }

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    function declareTrust(string calldata initiative, string calldata description) external onlyOverseer {
        trustCount++;
        trusts[trustCount] = Trust(trustCount, initiative, description, block.timestamp);
        emit TrustDeclared(trustCount, initiative, description);
    }
}
