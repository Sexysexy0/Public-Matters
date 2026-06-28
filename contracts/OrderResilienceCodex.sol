// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title OrderResilienceCodex
/// @notice Covenant contract to record cancellations and auto-reconciliation
contract OrderResilienceCodex {
    address public overseer;
    uint256 public orderCount;

    struct OrderEntry {
        uint256 id;
        string orderId;
        string status;
        string notes;
        uint256 timestamp;
    }

    mapping(uint256 => OrderEntry) public orders;

    event OrderResilienceLogged(uint256 indexed id, string orderId, string status);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logResilience(
        string calldata orderId,
        string calldata status,
        string calldata notes
    ) external onlyOverseer {
        orderCount++;
        orders[orderCount] = OrderEntry({
            id: orderCount,
            orderId: orderId,
            status: status,
            notes: notes,
            timestamp: block.timestamp
        });
        emit OrderResilienceLogged(orderCount, orderId, status);
    }

    function viewResilience(uint256 id) external view returns (OrderEntry memory) {
        return orders[id];
    }
}
