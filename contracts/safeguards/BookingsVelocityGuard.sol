// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title BookingsVelocityGuard
 * @notice Enforces time-locked capital commitments to counter contract execution slippage and guarantee pipeline transparency.
 */
contract BookingsVelocityGuard {
    event PipelineProjectLogged(bytes32 indexed dealId, address indexed clientAddress, uint256 structuralEscrowWei);
    event ConversionCleared(bytes32 indexed dealId, uint256 transferredVolume, uint256 processingBlock);
    event ProjectSlippageTriggered(bytes32 indexed dealId, uint256 extendedDeadlineBlock);
    event StewardRootTransferred(address indexed oldSteward, address indexed newSteward);

    address public masterStewardRoot;
    uint256 public totalActiveBookingsVolume;
    uint256 public constant ABSOLUTE_MAX_SLIPPAGE_WINDOWS = 3; // Maximum allowable times a project execution deadline can be extended

    struct AIProjectPipeline {
        address payable clientNode;
        uint256 committedEscrowBalance;
        uint256 processingDeadlineBlock;
        uint8 slippageCounter;
        bool isActive;
        bool convertedToRevenue;
        bool initialized;
    }

    // Mapping from unique corporate deal token to explicit pipeline parameters
    mapping(bytes32 => AIProjectPipeline) public engineeringPipelineRegistry;

    constructor() {
        masterStewardRoot = msg.sender;
    }

    modifier onlyMasterRoot() {
        require(msg.sender == masterStewardRoot, "Unauthorized Control: Master steward root validation failed");
        _;
    }

    /**
     * @notice Registers an inbound framework contract deal and locks tokenized capital to guarantee execution visibility.
     */
    function registerActiveBooking(
        bytes32 _dealId,
        address payable _clientNode,
        uint256 _executionWindowBlocks
    ) external payable onlyMasterRoot {
        require(_dealId != bytes32(0), "Parameter Error: Deal identifier token cannot be blank matrix parameters");
        require(_clientNode != address(0), "Parameter Error: Target client coordinate cannot be blank space");
        require(msg.value > 0, "Parameter Error: Structural booking escrow deposit weight must exceed zero");
        require(!engineeringPipelineRegistry[_dealId].initialized, "Collision Intercept: Target booking sequence already active inside state history");

        uint256 executionLimit = block.number + _executionWindowBlocks;

        engineeringPipelineRegistry[_dealId] = AIProjectPipeline({
            clientNode: _clientNode,
            committedEscrowBalance: msg.value,
            processingDeadlineBlock: executionLimit,
            slippageCounter: 0,
            isActive: true,
            convertedToRevenue: false,
            initialized: true
        });

        totalActiveBookingsVolume += msg.value;
        emit PipelineProjectLogged(_dealId, _clientNode, msg.value);
    }

    /**
     * @notice Converts the locked framework escrow allocation into active ecosystem revenue upon verified code deployment.
     */
    function finalizeBookingConversion(bytes32 _dealId, address payable _treasuryDestination) external onlyMasterRoot {
        AIProjectPipeline storage project = engineeringPipelineRegistry[_dealId];
        require(project.initialized, "Registry Exception: Targeted project track is uninstantiated inside memory");
        require(project.isActive && !project.convertedToRevenue, "State Error: Selected project track is closed or already finalized");
        require(block.number <= project.processingDeadlineBlock, "Temporal Guard: Project deadline has expired without conversion");
        require(_treasuryDestination != address(0), "Parameter Error: Target treasury destination profile cannot be empty");

        uint256 revenueVolume = project.committedEscrowBalance;
        project.committedEscrowBalance = 0;
        project.isActive = false;
        project.convertedToRevenue = true;
        
        totalActiveBookingsVolume -= revenueVolume;
        _treasuryDestination.transfer(revenueVolume);

        emit ConversionCleared(_dealId, revenueVolume, block.number);
    }

    /**
     * @notice Flags a transaction or development delay, updating temporal parameters within hardcoded compliance caps.
     */
    function flagProjectSlippage(bytes32 _dealId, uint256 _extensionBlocks) external onlyMasterRoot {
        AIProjectPipeline storage project = engineeringPipelineRegistry[_dealId];
        require(project.isActive, "State Error: Selected track is currently closed or restricted");
        require(project.slippageCounter < ABSOLUTE_MAX_SLIPPAGE_WINDOWS, "Compliance Block: Maximum target project timeline extensions breached");

        project.processingDeadlineBlock += _extensionBlocks;
        project.slippageCounter += 1;

        emit ProjectSlippageTriggered(_dealId, project.processingDeadlineBlock);
    }

    /**
     * @notice Shift the master central core cryptographic key signature coordinator.
     */
    function transferMasterStewardRoot(address _newSteward) external onlyMasterRoot {
        require(_newSteward != address(0), "Identity Error: Target root destination falls outside legal system registry parameters");
        masterStewardRoot = _newSteward;
        emit StewardRootTransferred(msg.sender, _newSteward);
    }
}
