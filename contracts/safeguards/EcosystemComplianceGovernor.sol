// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title EcosystemComplianceGovernor
/// @notice Central processing core contract to coordinate safeguard proposals, enforce deterministic multi-sig tracking, and execute structural consensus
contract EcosystemComplianceGovernor {
    event ProposalSubmitted(bytes32 indexed proposalId, bytes32 indexed targetComponentHash, uint256 executionEtaBlock);
    event GovernanceVoteLogged(bytes32 indexed proposalId, address indexed votingAgent, uint256 voteWeight);
    event ProposalExecuted(bytes32 indexed proposalId, bytes32 targetComponentHash);
    event ProposalVetoed(bytes32 indexed proposalId, string vetoReason);
    event GovernorStewardTransferred(address indexed oldSteward, address indexed newSteward);

    address public governorSteward;
    bool public strictConsensusEnforced;
    uint256 public constant PROPOSAL_VOTE_THRESHOLD = 75; // Minimum total alignment score out of 100 required to finalize changes

    struct GovernanceProposal {
        bytes32 targetComponentHash; // Identifies which shield contract or module is being modified
        uint256 submittedAtBlock;
        uint256 executionEtaBlock;
        uint256 combinedVoteWeight;  // Accumulated consensus validation index
        bool proposalActive;
        bool isFinalized;
        bool exists;
    }

    struct VoteAuditRecord {
        uint256 blockVoted;
        uint256 continuousWeight;
        bool voteApproved;
    }

    // Mapping from unique proposal tracking token to dynamic governance records
    mapping(bytes32 => GovernanceProposal) public proposalsHistory;
    // Mapping from proposal hash and agent key to historical vote registries
    mapping(bytes32 => mapping(address => VoteAuditRecord)) public governanceVotesVault;
    uint256 public totalProposalsLogged;

    constructor() {
        governorSteward = msg.sender;
        strictConsensusEnforced = true;
    }

    modifier onlySteward() {
        require(msg.sender == governorSteward, "Unauthorized: Governor Steward signature validation failed");
        _;
    }

    /// @notice Submit a transparent operational proposal to update or patch an existing safeguard component configuration
    function submitGovernanceProposal(
        bytes32 _proposalId,
        bytes32 _componentHash,
        uint256 _cooldownBlocks
    ) external onlySteward {
        require(_proposalId != bytes32(0) && _componentHash != bytes32(0), "Invalid framework proposal tracking parameters");
        require(!proposalsHistory[_proposalId].exists, "Governor Collision: Targeted proposal sequence already active inside memory");

        proposalsHistory[_proposalId] = GovernanceProposal({
            targetComponentHash: _componentHash,
            submittedAtBlock: block.number,
            executionEtaBlock: block.number + _cooldownBlocks,
            combinedVoteWeight: 0,
            proposalActive: true,
            isFinalized: false,
            exists: true
        });

        totalProposalsLogged += 1;
        emit ProposalSubmitted(_proposalId, _componentHash, block.number + _cooldownBlocks);
    }

    /// @notice Cast a certified programmatic governance validation check weight into an active proposal session
    /// @param _proposalId Unique chronological tracking token representing the active process instance
    /// @param _agent Target automated execution node address submitting the vote credentials
    /// @param _weight Allocation index tracking the structural authorization score (0 to 100)
    function castGovernanceVote(
        bytes32 _proposalId,
        address _agent,
        uint256 _weight
    ) external onlySteward {
        GovernanceProposal storage proposal = proposalsHistory[_proposalId];
        require(proposal.exists, "Access Denied: Target governance session is uninstantiated");
        require(proposal.proposalActive, "Security Block: Targeted proposal track is currently closed or restricted");
        require(_weight <= 100, "Parameter Error: Individual alignment weight exceeds core structural limits");

        governanceVotesVault[_proposalId][_agent] = VoteAuditRecord({
            blockVoted: block.number,
            continuousWeight: _weight,
            voteApproved: true
        });

        proposal.combinedVoteWeight += _weight;
        emit GovernanceVoteLogged(_proposalId, _agent, _weight);
    }

    /// @notice Permanently merge and execute a queued governance configuration update once baseline consensus metrics clear
    function finalizeGovernanceProposal(bytes32 _proposalId) external onlySteward {
        GovernanceProposal storage proposal = proposalsHistory[_proposalId];
        require(proposal.exists, "Target structural proposal profile does not exist");
        require(!proposal.isFinalized, "Execution Status: Selected track is already permanently integrated");
        require(block.number >= proposal.executionEtaBlock, "Temporal Guard Lock: Cooldown matrix enforcement period active");

        proposal.proposalActive = false;
        proposal.isFinalized = true;

        // Consensus Guard Gate: Automatically aborts execution if logic weights fail to clear the minimal threshold
        if (strictConsensusEnforced && proposal.combinedVoteWeight < PROPOSAL_VOTE_THRESHOLD) {
            emit ProposalVetoed(_proposalId, "Consensus Fault: Accumulated validation weights fail to clear secure threshold requirements");
            return;
        }

        emit ProposalExecuted(_proposalId, proposal.targetComponentHash);
    }

    /// @notice Instantly veto and purge an unverified transaction or risky proposal trail from the system lifecycle history
    function emergencyVetoProposal(bytes32 _proposalId, string calldata _reason) external onlySteward {
        require(proposalsHistory[_proposalId].exists, "Target infrastructure profile does not exist");
        require(!proposalsHistory[_proposalId].isFinalized, "Imbalance Loop: Cannot revoke a proposal that has already merged into baseline configurations");

        proposalsHistory[_proposalId].proposalActive = false;
        proposalsHistory[_proposalId].isFinalized = true;
        
        emit ProposalVetoed(_proposalId, _reason);
    }

    /// @notice Toggle the automated multi-signature governance synchronization constraints
    function toggleStrictConsensus(bool _status) external onlySteward {
        strictConsensusEnforced = _status;
    }

    /// @notice Upgrade or shift the central consensus framework block to an updated gateway master node
    function transferGovernorStewardship(address _newSteward) external onlySteward {
        require(_newSteward != address(0), "Invalid target deployment destination tracking coordinates");
        governorSteward = _newSteward;
        emit GovernorStewardTransferred(msg.sender, _newSteward);
    }
}
