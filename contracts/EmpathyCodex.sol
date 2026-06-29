// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title EmpathyCodex
/// @notice Covenant contract to safeguard communities through systemic anchoring of empathy safeguards
contract EmpathyCodex {
    address public overseer;
    uint256 public empathyCount;

    struct EmpathyEntry {
        uint256 id;
        string actor;
        string context;
        string principle;
        uint256 timestamp;
    }

    mapping(uint256 => EmpathyEntry) public empathies;

    event EmpathyLogged(uint256 indexed id, string actor, string context);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logEmpathy(
        string calldata actor,
        string calldata context,
        string calldata principle
    ) external onlyOverseer {
        empathyCount++;
        empathies[empathyCount] = EmpathyEntry({
            id: empathyCount,
            actor: actor,
            context: context,
            principle: principle,
            timestamp: block.timestamp
        });
        emit EmpathyLogged(empathyCount, actor, context);
    }

    function viewEmpathy(uint256 id) external view returns (EmpathyEntry memory) {
        return empathies[id];
    }
}
