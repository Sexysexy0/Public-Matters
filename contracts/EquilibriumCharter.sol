// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract EquilibriumCharter {
    address public overseer;
    uint256 public charterCount;

    struct Charter {
        uint256 id;
        string principle;   // Balance, Stability, Fairness
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => Charter) public charters;
    event CharterSigned(uint256 indexed id, string principle, string description);

    constructor(address _overseer) {
        overseer = _overseer;
    }

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    function signCharter(string calldata principle, string calldata description) external onlyOverseer {
        charterCount++;
        charters[charterCount] = Charter(charterCount, principle, description, block.timestamp);
        emit CharterSigned(charterCount, principle, description);
    }
}
