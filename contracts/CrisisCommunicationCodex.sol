// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title CrisisCommunicationCodex
/// @notice Covenant contract to safeguard communities through rapid crisis communication protocols
contract CrisisCommunicationCodex {
    address public overseer;
    uint256 public commCount;

    struct CommEntry {
        uint256 id;
        string scenario;
        string channel;
        string protocol;
        uint256 timestamp;
    }

    mapping(uint256 => CommEntry) public communications;

    event CommLogged(uint256 indexed id, string scenario, string channel);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logComm(
        string calldata scenario,
        string calldata channel,
        string calldata protocol
    ) external onlyOverseer {
        commCount++;
        communications[commCount] = CommEntry({
            id: commCount,
            scenario: scenario,
            channel: channel,
            protocol: protocol,
            timestamp: block.timestamp
        });
        emit CommLogged(commCount, scenario, channel);
    }

    function viewComm(uint256 id) external view returns (CommEntry memory) {
        return communications[id];
    }
}
