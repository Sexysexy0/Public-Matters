// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title SafetyOversightCodex
/// @notice Covenant contract to safeguard accountability through oversight of safety protocols
contract SafetyOversightCodex {
    address public overseer;
    uint256 public oversightCount;

    struct OversightEntry {
        uint256 id;
        string protocol;
        string status;
        string remarks;
        uint256 timestamp;
    }

    mapping(uint256 => OversightEntry) public oversights;

    event OversightLogged(uint256 indexed id, string protocol, string status);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logOversight(
        string calldata protocol,
        string calldata status,
        string calldata remarks
    ) external onlyOverseer {
        oversightCount++;
        oversights[oversightCount] = OversightEntry({
            id: oversightCount,
            protocol: protocol,
            status: status,
            remarks: remarks,
            timestamp: block.timestamp
        });
        emit OversightLogged(oversightCount, protocol, status);
    }

    function viewOversight(uint256 id) external view returns (OversightEntry memory) {
        return oversights[id];
    }
}
