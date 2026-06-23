// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title SelectiveSpendingProxy
 * @notice Implements resource optimization frameworks utilizing low-level Yul data routing to enforce flat budget constraints across network modules.
 */
contract SelectiveSpendingProxy {
    event AllocationThrottled(bytes4 indexed functionSignature, uint256 internalGasCap);
    event LogicModuleTargetUpgraded(address indexed oldModule, address indexed newModule);
    event ProxyOwnershipTransferred(address indexed oldOwner, address indexed newOwner);

    // Storage Slot 0: Packed Configuration Matrix (Low-Level Memory Layout Optimization)
    // Bits 0-127: Global strict gas/spending ceiling for legacy processes (uint128)
    // Bits 128-135: Budget optimization switch flag (bool/uint8)
    // Bits 136-255: Unallocated configuration metadata parameters
    bytes32 public packedProxyMetadata;

    // Storage Slot 1 & 2: Execution targets
    address public targetAILogicModule;
    address public proxyOwnerRoot;

    constructor(address _initialAIModule, uint128 _initialLegacyCeiling) {
        proxyOwnerRoot = msg.sender;
        targetAILogicModule = _initialAIModule;
        
        // Initialize structural packing state: legacy allocation ceiling, optimization flag = true
        updateSpendingConstraints(_initialLegacyCeiling, true);
    }

    modifier onlyOwnerRoot() {
        require(msg.sender == proxyOwnerRoot, "Proxy Guard: Root deployment key validation trace failed");
        _;
    }

    /**
     * @notice Encodes and updates the compressed storage structure variable allocation matrices using bit shifting.
     */
    function updateSpendingConstraints(uint128 _legacyGasCeiling, bool _optimizationActive) public onlyOwnerRoot {
        bytes32 dynamicPacked;
        uint8 optFlag = _optimizationActive ? 1 : 0;

        dynamicPacked = bytes32(uint256(_legacyGasCeiling));
        dynamicPacked |= bytes32(uint256(optFlag) << 128);

        packedProxyMetadata = dynamicPacked;
    }

    /**
     * @notice Upgrades the primary AI execution routing architecture location.
     */
    function upgradeAILogicModule(address _newAIModule) external onlyOwnerRoot {
        require(_newAIModule != address(0), "Optimization Error: New target module coordinates cannot be empty");
        address oldModule = targetAILogicModule;
        targetAILogicModule = _newAIModule;

        emit LogicModuleTargetUpgraded(oldModule, _newAIModule);
    }

    /**
     * @notice Low-level fallback routing structure enforcing precise spending limits on legacy function selectors.
     */
    fallback() external payable {
        address targetModule = targetAILogicModule;
        bytes32 metadataSlot = packedProxyMetadata;

        assembly {
            // Isolate individual packed values from the central storage layout block
            let legacyCeiling := and(metadataSlot, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
            let optActive := and(shr(128, metadataSlot), 0xFF)

            // Extract the function signature selector from inbound call transactional data (first 4 bytes)
            let sigSelector := shr(224, calldataload(0))

            // Dynamic Throttling Gate: If optimization is active, evaluate if call targets generic or unoptimized legacy logic
            // Exemplifying signature checks for known heavy/unoptimized legacy validation functions
            if iszero(iszero(optActive)) {
                // If specific legacy operation matches, check remaining available processing cycle margins
                if eq(sigSelector, 0xA9059CBB) { // Mock signature representing legacy non-optimized sub-processes
                    if gt(gas(), legacyCeiling) {
                        // Hard intercept execution loop and drop processing state if resource limits are exceeded
                        mstore(0x00, 0x08c379a0) // Hash signature of: Error(string)
                        mstore(0x04, 0x20)
                        mstore(0x24, 0x23)
                        mstore(0x44, "Proxy Block: Gas Ceiling Exceeded")
                        revert(0x00, 0x64)
                    }
                }
            }

            // Copy dynamic input payload arguments straight into the bare memory allocations
            calldatacopy(0, 0, calldatasize())

            // Forward the payload directly to the primary high-yield AI destination logic core
            let executionResult := delegatecall(gas(), targetModule, 0, calldatasize(), 0, 0)

            // Gather transaction return telemetry from the output buffers
            returndatacopy(0, 0, returndatasize())

            switch executionResult
            case 0 {
                revert(0, returndatasize())
            }
            default {
                return(0, returndatasize())
            }
        }
    }

    receive() external payable {}

    /**
     * @notice Shift the master proxy cryptographic configuration signature anchor destination.
     */
    function transferProxyOwnership(address _newOwner) external onlyOwnerRoot {
        require(_newOwner != address(0), "Identity Exception: Target structural destination coordinate falls outside registry parameters");
        proxyOwnerRoot = _newOwner;
        emit ProxyOwnershipTransferred(msg.sender, _newOwner);
    }
}
