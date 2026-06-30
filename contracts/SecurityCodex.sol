// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SecurityCodex {
    address public overseer;
    uint256 public securityCount;

    struct SecurityRule {
        uint256 id;
        string principle; // Data Protection, Access Control, Threat Mitigation, Compliance
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => SecurityRule) public securities;

    event SecurityLogged(uint256 indexed id, string principle, string description);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logSecurity(
        string calldata principle,
        string calldata description
    ) external onlyOverseer {
        securityCount++;
        securities[securityCount] = SecurityRule({
            id: securityCount,
            principle: principle,
            description: description,
            timestamp: block.timestamp
        });
        emit SecurityLogged(securityCount, principle, description);
    }

    function viewSecurity(uint256 id) external view returns (SecurityRule memory) {
        return securities[id];
    }
}
