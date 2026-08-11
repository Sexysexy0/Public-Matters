// SPDX-License-Identifier: MIT
pragma solidity 0.8.35;

/**
 * @title TransientSupplyPassport
 * @notice Leverages EIP-1153 transient storage (tstore/tload) for gas-efficient,
 * single-transaction supply chain provenance and verification.
 */
contract TransientSupplyPassport {
    address public immutable owner;

    // Transient storage slots keys
    bytes32 PRIVATE_BATCH_HASH_SLOT = keccak256("TRANSIENT_BATCH_HASH");
    bytes32 PRIVATE_INSPECTOR_SLOT = keccak256("TRANSIENT_INSPECTOR");

    event BatchVerified(uint256 indexed batchId, bytes32 batchHash, address indexed inspector);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner permitted");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function setTransientBatchData(bytes32 batchHash) external {
        bytes32 slotHash = PRIVATE_BATCH_HASH_SLOT;
        bytes32 slotInspector = PRIVATE_INSPECTOR_SLOT;
        address sender = msg.sender;

        assembly {
            tstore(slotHash, batchHash)
            tstore(slotInspector, sender)
        }
    }

    function getTransientBatchData() public view returns (bytes32 batchHash, address inspector) {
        bytes32 slotHash = PRIVATE_BATCH_HASH_SLOT;
        bytes32 slotInspector = PRIVATE_INSPECTOR_SLOT;

        assembly {
            batchHash := tload(slotHash)
            inspector := tload(slotInspector)
        }
    }

    function verifyAndLogBatch(uint256 batchId, bytes32 expectedHash) external returns (bool) {
        (bytes32 currentHash, address inspector) = getTransientBatchData();
        require(currentHash != bytes32(0), "No transient batch loaded");
        require(currentHash == expectedHash, "Batch hash mismatch");
        require(inspector != address(0), "Invalid inspector");

        emit BatchVerified(batchId, currentHash, inspector);
        return true;
    }
}
