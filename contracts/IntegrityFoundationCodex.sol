// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title IntegrityFoundationCodex
/// @notice Covenant contract to safeguard communities through systemic anchoring of integrity in governance
contract IntegrityFoundationCodex {
    address public overseer;
    uint256 public integrityCount;

    struct IntegrityEntry {
        uint256 id;
        string actor;
        string action;
        string context;
        uint256 timestamp;
    }

    mapping(uint256 => IntegrityEntry) public integrities;

    event IntegrityLogged(uint256 indexed id, string actor, string action);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logIntegrity(
        string calldata actor,
        string calldata action,
        string calldata context
    ) external onlyOverseer {
        integrityCount++;
        integrities[integrityCount] = IntegrityEntry({
            id: integrityCount,
            actor: actor,
            action: action,
            context: context,
            timestamp: block.timestamp
        });
        emit IntegrityLogged(integrityCount, actor, action);
    }

    function viewIntegrity(uint256 id) external view returns (IntegrityEntry memory) {
        return integrities[id];
    }
}
