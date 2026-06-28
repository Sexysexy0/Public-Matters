// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title InventorySyncLedger
/// @notice Covenant contract to record centralized inventory synchronization
contract InventorySyncLedger {
    address public overseer;
    uint256 public syncCount;

    struct SyncEntry {
        uint256 id;
        string sku;
        string sourceSystem;
        uint256 quantity;
        string notes;
        uint256 timestamp;
    }

    mapping(uint256 => SyncEntry) public syncs;

    event InventorySynced(uint256 indexed id, string sku, string sourceSystem);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logSync(
        string calldata sku,
        string calldata sourceSystem,
        uint256 quantity,
        string calldata notes
    ) external onlyOverseer {
        syncCount++;
        syncs[syncCount] = SyncEntry({
            id: syncCount,
            sku: sku,
            sourceSystem: sourceSystem,
            quantity: quantity,
            notes: notes,
            timestamp: block.timestamp
        });
        emit InventorySynced(syncCount, sku, sourceSystem);
    }

    function viewSync(uint256 id) external view returns (SyncEntry memory) {
        return syncs[id];
    }
}
