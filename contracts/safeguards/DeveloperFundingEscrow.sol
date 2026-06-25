// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title DeveloperFundingEscrow
 * @notice Implements conditional milestone funding locks to eliminate resource steering conflicts and protect system expansion capital.
 */
contract DeveloperFundingEscrow {
    event MilestoneRegistered(bytes32 indexed milestoneHash, uint256 payoutWeight, uint256 validationDeadline);
    event MilestoneVerifiedAndReleased(bytes32 indexed milestoneHash, address indexed developerNode, uint256 disbursedVolume);
    event FundingRevoked(bytes32 indexed milestoneHash, uint256 recoveredVolume, address indexed treasuryDestination);
    event StewardRootTransferred(address indexed oldSteward, address indexed newSteward);

    address public masterStewardRoot;
    uint256 public totalEscrowedVolume;

    struct FundingMilestone {
        address payable developerNodeAddress; // Targeted execution node tasked with completing the specific repository tracking milestone
        uint256 fundingAllocationWei; // Specific financial weight allocated to this operational sprint
        uint256 submissionDeadlineBlock;
        bool milestoneCleared;
        bool isRevoked;
        bool initialized;
    }

    // Mapping from explicit milestone cryptographic data hash to internal registry configurations
    mapping(bytes32 => FundingMilestone) public milestonesVault;

    constructor() {
        masterStewardRoot = msg.sender;
    }

    modifier onlyMasterRoot() {
        require(msg.sender == masterStewardRoot, "Access Denied: Master steward identity token signature validation failed");
        _;
    }

    /**
     * @notice Secure entry point to fund the escrow contract layer and map explicit tracking rules to internal memory.
     */
    function registerMilestoneTrack(
        bytes32 _milestoneHash,
        address payable _developerNode,
        uint256 _deadlineDurationBlocks
    ) external payable onlyMasterRoot {
        require(_milestoneHash != bytes32(0), "Parameter Error: Cryptographic milestone identity token cannot be empty");
        require(_developerNode != address(0), "Parameter Error: Target developer execution node profile coordinate cannot be blank");
        require(msg.value > 0, "Parameter Error: Escrow injection allocation weight must exceed zero units");
        require(!milestonesVault[_milestoneHash].initialized, "Collision Intercept: Selected milestone trajectory already active inside state history");

        uint256 deadlineBlock = block.number + _deadlineDurationBlocks;

        milestonesVault[_milestoneHash] = FundingMilestone({
            developerNodeAddress: _developerNode,
            fundingAllocationWei: msg.value,
            submissionDeadlineBlock: deadlineBlock,
            milestoneCleared: false,
            isRevoked: false,
            initialized: true
        });

        totalEscrowedVolume += msg.value;
        emit MilestoneRegistered(_milestoneHash, msg.value, deadlineBlock);
    }

    /**
     * @notice Cryptographic consensus gate to verify project compliance data and trigger immediate asset release to the verified developer node.
     */
    function verifyAndReleaseMilestone(bytes32 _milestoneHash) external onlyMasterRoot {
        FundingMilestone storage sprint = milestonesVault[_milestoneHash];
        require(sprint.initialized, "Registry Exception: Targeted milestone profile coordinate does not exist inside repository");
        require(!sprint.milestoneCleared, "Execution Status: Selected milestone funding allocation track is already cleared");
        require(!sprint.isRevoked, "Security Exception: Target funding allocation has been permanently closed by master administrative intervention");
        require(block.number <= sprint.submissionDeadlineBlock, "Temporal Guard Lock: Target milestone execution window has expired");

        uint256 releaseAmount = sprint.fundingAllocationWei;
        require(address(this).balance >= releaseAmount, "Vault Exception: Insufficient floating network liquidity inside contract ledger");

        sprint.milestoneCleared = true;
        totalEscrowedVolume -= releaseAmount;
        sprint.developerNodeAddress.transfer(releaseAmount);

        emit MilestoneVerifiedAndReleased(_milestoneHash, sprint.developerNodeAddress, releaseAmount);
    }

    /**
     * @notice Emergency administrative function to instantly seize and reclaim locked capital allocations under toxic breakaway scenarios.
     */
    function emergencyRevokeFunding(bytes32 _milestoneHash, address payable _treasuryDestination) external onlyMasterRoot {
        FundingMilestone storage sprint = milestonesVault[_milestoneHash];
        require(sprint.initialized, "Registry Exception: Selected architecture tracking queue coordinate is uninstantiated");
        require(!sprint.milestoneCleared, "Imbalance Loop: Cannot revoke configuration data that has already executed and cleared the verification gates");
        require(!sprint.isRevoked, "State Error: Selected target track has already been revoked from the system registers");
        require(_treasuryDestination != address(0), "Parameter Error: Destination treasury location profile coordinates cannot be empty");

        uint256 recoveredVolume = sprint.fundingAllocationWei;
        sprint.isRevoked = true;
        sprint.fundingAllocationWei = 0;
        totalEscrowedVolume -= recoveredVolume;

        _treasuryDestination.transfer(recoveredVolume);

        emit FundingRevoked(_milestoneHash, recoveredVolume, _treasuryDestination);
    }

    /**
     * @notice Shift the master central core consensus signature pointer reference destination coordinate.
     */
    function transferStewardRoot(address _newSteward) external onlyMasterRoot {
        require(_newSteward != address(0), "Identity Error: Target coordinate destination falls outside structural framework bounds");
        masterStewardRoot = _newSteward;
        emit StewardRootTransferred(msg.sender, _newSteward);
    }

    /**
     * @notice Fallback interface allowing the framework to host generic loose liquidity floats inside storage slots.
     */
    fallback() external payable {}
    receive() external payable {}
}
