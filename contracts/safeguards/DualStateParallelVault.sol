// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title DualStateParallelVault
 * @notice Implements parallel asynchronous state tracking channels (Joy and Grief) to maintain system availability during accounting or structural friction.
 */
contract DualStateParallelVault {
    event PipelineThreadStateToggled(bytes32 indexed pipelineId, ChannelState activeState, uint256 blockTimestamp);
    event AssetsDisbursedParallel(bytes32 indexed pipelineId, address indexed targetNode, uint256 operationalVolumeWei);
    event VaultStewardTransferred(address indexed oldSteward, address indexed newSteward);

    address public vaultSteward;
    uint256 public totalActiveThreads;

    enum ChannelState { OptimalJoy, AnomalousGrief }

    struct ParallelChannelProfile {
        address payable destinationNode;
        uint256 activeLiquidityAllocation;
        ChannelState activeStatus;
        bool processingAllowedDuringGrief;
        bool initialized;
    }

    // Main tracking register mapping individual operational pipeline hashes to parallel data structures
    mapping(bytes32 => ParallelChannelProfile) public asynchronousRegistry;

    constructor() {
        vaultSteward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == vaultSteward, "Unauthorized Control: Vault steward credential audit failed");
        _;
    }

    /**
     * @notice Onboards a state tracking data pipeline with automated parallel recovery flags.
     */
    function registerParallelPipeline(
        bytes32 _pipelineId,
        address payable _destinationNode,
        bool _allowGriefProcessing
    ) external payable onlySteward {
        require(_pipelineId != bytes32(0) && _destinationNode != address(0), "Parameter Error: Invalid architectural specifications");
        require(!asynchronousRegistry[_pipelineId].initialized, "Collision Intercept: Target tracking loop is currently instantiated");

        asynchronousRegistry[_pipelineId] = ParallelChannelProfile({
            destinationNode: _destinationNode,
            activeLiquidityAllocation: msg.value,
            activeStatus: ChannelState.OptimalJoy, // Starts default at optimal execution configuration
            processingAllowedDuringGrief: _allowGriefProcessing,
            initialized: true
        });

        totalActiveThreads += 1;
    }

    /**
     * @notice Modulates the specific channel tracking states based on external infrastructure telemetry updates.
     */
    function toggleChannelOperationalState(bytes32 _pipelineId, ChannelState _targetState) external onlySteward {
        ParallelChannelProfile storage stream = asynchronousRegistry[_pipelineId];
        require(stream.initialized, "Registry Exception: Target profile coordinate does not exist inside repository");
        
        stream.activeStatus = _targetState;
        emit PipelineThreadStateToggled(_pipelineId, _targetState, block.timestamp);
    }

    /**
     * @notice Execution Solution: Validates that asset flow remains uninterrupted even under structural anomaly logs.
     */
    function executeParallelDisbursement(bytes32 _pipelineId, uint256 _disburseAmountWei) external onlySteward {
        ParallelChannelProfile storage stream = asynchronousRegistry[_pipelineId];
        require(stream.initialized, "Registry Exception: Specified architectural tracking channel is uninstantiated");
        require(address(this).balance >= _disburseAmountWei, "Vault Exception: Insufficient floating native liquidity inside ledger slots");

        // Parallel Gate: If the thread is in an Anomalous Grief state, bypass execution unless override processing permission is flagged
        if (stream.activeStatus == ChannelState.AnomalousGrief) {
            require(stream.processingAllowedDuringGrief, "Security Intercept: Channel operations are strictly locked due to active anomaly state friction");
        }

        stream.activeLiquidityAllocation -= _disburseAmountWei;
        stream.destinationNode.transfer(_disburseAmountWei);

        emit AssetsDisbursedParallel(_pipelineId, stream.destinationNode, _disburseAmountWei);
    }

    /**
     * @notice Fallback deposit gateways allowing the pipeline to warehouse runtime system assets.
     */
    fallback() external payable {}
    receive() external payable {}

    /**
     * @notice Shift the master core cryptographic consensus reference anchor destination.
     */
    function transferVaultStewardRoot(address _newSteward) external onlySteward {
        require(_newSteward != address(0), "Identity Error: Target root coordinate falls outside legal registry dimensions");
        vaultSteward = _newSteward;
        emit VaultStewardTransferred(msg.sender, _newSteward);
    }
}
