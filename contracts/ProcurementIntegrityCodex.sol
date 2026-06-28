// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ProcurementIntegrityCodex
/// @notice Covenant contract to safeguard procurement transparency and prevent overpricing
contract ProcurementIntegrityCodex {
    address public overseer;
    uint256 public procurementCount;

    struct ProcurementEntry {
        uint256 id;
        string item;
        string principle;
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => ProcurementEntry) public procurements;

    event ProcurementSafeguardLogged(uint256 indexed id, string item, string principle);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logProcurement(
        string calldata item,
        string calldata principle,
        string calldata description
    ) external onlyOverseer {
        procurementCount++;
        procurements[procurementCount] = ProcurementEntry({
            id: procurementCount,
            item: item,
            principle: principle,
            description: description,
            timestamp: block.timestamp
        });
        emit ProcurementSafeguardLogged(procurementCount, item, principle);
    }

    function viewProcurement(uint256 id) external view returns (ProcurementEntry memory) {
        return procurements[id];
    }
}
