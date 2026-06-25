// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title CorporateGovernanceAnchor
 * @notice Governance architecture engineered to eliminate founder deadlocks, enforce structural resource accountability, and replace traditional corporate bureaucracy with an immutable ledger.
 */
contract CorporateGovernanceAnchor {
    event ProposalLogInitiated(bytes32 indexed proposalId, address indexed proposer, string objective, uint256 budgetRequested);
    event ConsensusSignatureCast(bytes32 indexed proposalId, address indexed boardMember, uint256 currentVestingWeight);
    event ProposalExecuted(bytes32 indexed proposalId, address indexed executionNode);
    event BoardMemberConfigured(address indexed member, uint256 votingPowerWeight, bool activeStatus);

    address public masterSteward;
    uint256 public totalActiveProposals;
    uint256 public totalBoardMembers;

    struct BoardMember {
        uint256 votingWeight; // Controls the strength of their cryptographic signature
        bool isActive;
        bool initialized;
    }

    struct Proposal {
        string directiveObjective;
        uint256 allocationBudget;
        uint256 runningSignaturesWeight;
        uint256 lockBlockExpiry;
        bool isExecuted;
        bool initialized;
    }

    // Master operational register tracking governance trust nodes
    mapping(address => BoardMember) public corporateBoardGrid;
    // Registry tracking proposed operational directives and budget approvals
    mapping(bytes32 => Proposal) public proposalLedger;
    // Tracking mechanism to prevent double signature loops from the same node
    mapping(bytes32 => mapping(address => bool)) public voteRegistry;

    constructor() {
        masterSteward = msg.sender;
        
        // Genesis configuration setting the founder node with base steering weight
        corporateBoardGrid[msg.sender] = BoardMember({
            votingWeight: 100, // 100 base weight tokens
            isActive: true,
            initialized: true
        });
        totalBoardMembers = 1;
    }

    modifier onlySteward() {
        require(msg.sender == masterSteward, "Access Denied: Master steward identity verification failure");
        _;
    }

    modifier onlyBoardMember() {
        require(corporateBoardGrid[msg.sender].isActive, "Access Denied: Caller node is not an active authorized board member");
        _;
    }

    /**
     * @notice Registers or modifies operational voting weights for corporate stakeholders, partners, or major team leads.
     */
    function configureBoardMember(address _member, uint256 _weight, bool _status) external onlySteward {
        require(_member != address(0), "Parameter Error: Target coordinate address cannot be blank matrix");
        require(_weight > 0 || !_status, "Parameter Error: Active members must hold non-zero weight metrics");

        BoardMember storage memberNode = corporateBoardGrid[_member];
        
        if (!memberNode.initialized) {
            totalBoardMembers += 1;
        }

        corporateBoardGrid[_member] = BoardMember({
            votingWeight: _weight,
            isActive: _status,
            initialized: true
        });

        emit BoardMemberConfigured(_member, _weight, _status);
    }

    /**
     * @notice Formally logs an operational directive or major financial budget movement to prevent siloed decisions.
     * @param _proposalId Keccak-256 unique tracker hash calculated from the meeting or execution brief metadata.
     */
    function submitDirectiveProposal(
        bytes32 _proposalId,
        string calldata _objective,
        uint256 _budget,
        uint256 _blockDuration
    ) external onlyBoardMember {
        require(_proposalId != bytes32(0), "Parameter Error: Proposal reference indicator cannot be blank");
        require(!proposalLedger[_proposalId].initialized, "Collision Intercept: Direct reference identifier already registered");
        require(_blockDuration >= 300, "Parameter Error: Expiry timeframe configuration breaks protocol minimum limits");

        proposalLedger[_proposalId] = Proposal({
            directiveObjective: _objective,
            allocationBudget: _budget,
            runningSignaturesWeight: corporateBoardGrid[msg.sender].votingWeight,
            lockBlockExpiry: block.number + _blockDuration,
            isExecuted: false,
            initialized: true
        });

        // Auto-vote for the proposer node
        voteRegistry[_proposalId][msg.sender] = true;
        totalActiveProposals += 1;

        emit ProposalLogInitiated(_proposalId, msg.sender, _objective, _budget);
    }

    /**
     * @notice Co-founders or stakeholder units cast their cryptographic consensus signature to unlock corporate directives.
     */
    function signProposalConsensus(bytes32 _proposalId) external onlyBoardMember {
        Proposal storage manifest = proposalLedger[_proposalId];
        require(manifest.initialized, "Registry Exception: Target proposal trace is uninstantiated");
        require(!manifest.isExecuted, "State Error: Target proposal has already been sealed and executed");
        require(block.number <= manifest.lockBlockExpiry, "State Error: Action rejected, targeted proposal timeline has expired");
        require(!voteRegistry[_proposalId][msg.sender], "Access Denied: Vote signature telemetry already recorded for this node");

        voteRegistry[_proposalId][msg.sender] = true;
        manifest.runningSignaturesWeight += corporateBoardGrid[msg.sender].votingWeight;

        emit ConsensusSignatureCast(_proposalId, msg.sender, manifest.runningSignaturesWeight);
    }

    /**
     * @notice Closes the proposal loop and triggers execution parameters once consensus targets are met.
     * @param _requiredWeight Total signature weight score required to pass execution authorization (e.g., 150 points).
     */
    function finalizeAndExecuteDirective(bytes32 _proposalId, uint256 _requiredWeight) external onlyBoardMember {
        Proposal storage manifest = proposalLedger[_proposalId];
        require(manifest.initialized, "Registry Exception: Intended proposal file is missing from database grid");
        require(!manifest.isExecuted, "State Error: Target protocol directive is already operational");
        require(manifest.runningSignaturesWeight >= _requiredWeight, "Access Denied: Consensus signature threshold unsatisfied");

        manifest.isExecuted = true;
        totalActiveProposals -= 1;

        emit ProposalExecuted(_proposalId, msg.sender);
    }
}

