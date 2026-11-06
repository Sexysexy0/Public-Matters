// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./OperatorPrivileges.sol";

contract HardwareAllocationRegistry {
    OperatorPrivileges public immutable privileges;

    struct Batch {
        bytes32 batchId;
        bytes32 itemHash;       // e.g., "Switch Cartridge 32GB"
        uint256 manufacturedQty;
        uint256 distributedQty;
        bytes32 regionHash;
        uint256 updatedAt;
    }

    mapping(bytes32 => Batch) public batches;

    event BatchRegistered(bytes32 indexed batchId, bytes32 indexed itemHash, uint256 qty, bytes32 regionHash);
    event BatchDistributed(bytes32 indexed batchId, uint256 qty, bytes32 destinationHash);

    modifier onlyOperator() {
        require(privileges.isOperator(msg.sender), "Not authorized operator");
        _;
    }

    constructor(address _privileges) {
        require(_privileges != address(0), "privileges=0");
        privileges = OperatorPrivileges(_privileges);
    }

    function registerBatch(bytes32 batchId, bytes32 itemHash, uint256 qty, bytes32 regionHash) external onlyOperator {
        require(batches[batchId].updatedAt == 0, "Batch exists");
        require(qty > 0, "Qty=0");

        batches[batchId] = Batch({
            batchId: batchId,
            itemHash: itemHash,
            manufacturedQty: qty,
            distributedQty: 0,
            regionHash: regionHash,
            updatedAt: block.timestamp
        });

        emit BatchRegistered(batchId, itemHash, qty, regionHash);
    }

    function distributeBatch(bytes32 batchId, uint256 qty, bytes32 destinationHash) external onlyOperator {
        Batch storage b = batches[batchId];
        require(b.updatedAt != 0, "Batch not found");
        require(b.distributedQty + qty <= b.manufacturedQty, "Exceeds manufactured qty");

        b.distributedQty += qty;
        b.updatedAt = block.timestamp;

        emit BatchDistributed(batchId, qty, destinationHash);
    }
}
