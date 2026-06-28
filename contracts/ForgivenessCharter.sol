// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ForgivenessCharter
/// @notice Covenant contract to safeguard communities through systemic anchoring of forgiveness practices
contract ForgivenessCharter {
    address public overseer;
    uint256 public forgivenessCount;

    struct ForgivenessEntry {
        uint256 id;
        string actor;
        string recipient;
        string method;
        uint256 timestamp;
    }

    mapping(uint256 => ForgivenessEntry) public forgivenesses;

    event ForgivenessLogged(uint256 indexed id, string actor, string recipient);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logForgiveness(
        string calldata actor,
        string calldata recipient,
        string calldata method
    ) external onlyOverseer {
        forgivenessCount++;
        forgivenesses[forgivenessCount] = ForgivenessEntry({
            id: forgivenessCount,
            actor: actor,
            recipient: recipient,
            method: method,
            timestamp: block.timestamp
        });
        emit ForgivenessLogged(forgivenessCount, actor, recipient);
    }

    function viewForgiveness(uint256 id) external view returns (ForgivenessEntry memory) {
        return forgivenesses[id];
    }
}
