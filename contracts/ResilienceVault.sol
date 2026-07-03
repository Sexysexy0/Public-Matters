// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ResilienceVault {
    address public overseer;
    uint256 public safeguardCount;

    struct Safeguard {
        uint256 id;
        string mechanism;
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => Safeguard) public safeguards;
    event SafeguardStored(uint256 indexed id, string mechanism, string description);

    constructor(address _overseer) {
        overseer = _overseer;
    }

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    function storeSafeguard(string calldata mechanism, string calldata description) external onlyOverseer {
        safeguardCount++;
        safeguards[safeguardCount] = Safeguard(safeguardCount, mechanism, description, block.timestamp);
        emit SafeguardStored(safeguardCount, mechanism, description);
    }
}
