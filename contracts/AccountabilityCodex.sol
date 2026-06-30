// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AccountabilityCodex {
    address public overseer;
    uint256 public accountabilityCount;

    struct AccountabilityRule {
        uint256 id;
        string principle; // Oversight, Reporting, Responsibility, Transparency
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => AccountabilityRule) public accountabilities;

    event AccountabilityLogged(uint256 indexed id, string principle, string description);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logAccountability(
        string calldata principle,
        string calldata description
    ) external onlyOverseer {
        accountabilityCount++;
        accountabilities[accountabilityCount] = AccountabilityRule({
            id: accountabilityCount,
            principle: principle,
            description: description,
            timestamp: block.timestamp
        });
        emit AccountabilityLogged(accountabilityCount, principle, description);
    }

    function viewAccountability(uint256 id) external view returns (AccountabilityRule memory) {
        return accountabilities[id];
    }
}
