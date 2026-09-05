// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract BrittleInstrument {
    struct Operation {
        string description;
        uint256 expiryBlock;
        address initiator;
    }

    Operation[] public operations;

    event OperationStarted(uint256 id, string description, uint256 expiryBlock);
    event OperationExpired(uint256 id);

    function startOperation(string calldata description, uint256 durationBlocks) external {
        uint256 expiry = block.number + durationBlocks;
        operations.push(Operation(description, expiry, msg.sender));
        emit OperationStarted(operations.length - 1, description, expiry);
    }

    function isActive(uint256 id) external view returns (bool) {
        return block.number <= operations[id].expiryBlock;
    }
}
