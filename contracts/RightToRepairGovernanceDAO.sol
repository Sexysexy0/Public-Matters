// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title RightToRepairGovernanceDAO
/// @notice Secure governance DAO with duplicate voter prevention and access control
contract RightToRepairGovernanceDAO {
    address public admin;
    address public pendingAdmin;

    struct Proposal {
        uint256 id;
        string topic;
        uint256 votesFor;
        uint256 votesAgainst;
        bool active;
        uint256 timestamp;
    }

    uint256 public proposalCount;
    mapping(uint256 => Proposal) public proposals;
    mapping(uint256 => mapping(address => bool)) public hasVoted;
    mapping(address => bool) public whitelistedVoters;

    event ProposalCreated(uint256 indexed id, string topic, uint256 timestamp);
    event Voted(uint256 indexed id, address indexed voter, bool support);
    event ProposalClosed(uint256 indexed id, uint256 votesFor, uint256 votesAgainst);
    event AdminTransferInitiated(address indexed newAdmin);
    event AdminTransferred(address indexed oldAdmin, address indexed newAdmin);
    event VoterWhitelisted(address indexed voter);
    event VoterRemoved(address indexed voter);

    modifier onlyAdmin() {
        require(msg.sender == admin, "RightToRepairGovernanceDAO: Only admin");
        _;
    }

    modifier validInput(string memory _str) {
        require(bytes(_str).length > 0, "RightToRepairGovernanceDAO: Input empty");
        require(bytes(_str).length <= 256, "RightToRepairGovernanceDAO: Input too long");
        _;
    }

    constructor() {
        admin = msg.sender;
        whitelistedVoters[msg.sender] = true;
    }

    /// @notice Create a new proposal
    /// @param topic Proposal topic
    function createProposal(string memory topic)
        external
        onlyAdmin
        validInput(topic)
    {
        proposalCount++;
        proposals[proposalCount] = Proposal(
            proposalCount,
            topic,
            0,
            0,
            true,
            block.timestamp
        );
        emit ProposalCreated(proposalCount, topic, block.timestamp);
    }

    /// @notice Vote on a proposal
    /// @param id Proposal ID
    /// @param support True for yes, false for no
    function vote(uint256 id, bool support) external {
        require(id > 0 && id <= proposalCount, "RightToRepairGovernanceDAO: Invalid proposal");
        require(proposals[id].active, "RightToRepairGovernanceDAO: Proposal not active");
        require(whitelistedVoters[msg.sender], "RightToRepairGovernanceDAO: Not whitelisted");
        require(!hasVoted[id][msg.sender], "RightToRepairGovernanceDAO: Already voted");

        hasVoted[id][msg.sender] = true;

        if (support) {
            proposals[id].votesFor++;
        } else {
            proposals[id].votesAgainst++;
        }

        emit Voted(id, msg.sender, support);
    }

    /// @notice Whitelist a voter
    /// @param voter Address to whitelist
    function whitelistVoter(address voter) external onlyAdmin {
        require(voter != address(0), "RightToRepairGovernanceDAO: Invalid address");
        whitelistedVoters[voter] = true;
        emit VoterWhitelisted(voter);
    }

    /// @notice Remove a voter from whitelist
    /// @param voter Address to remove
    function removeVoter(address voter) external onlyAdmin {
        whitelistedVoters[voter] = false;
        emit VoterRemoved(voter);
    }

    /// @notice Close a proposal
    /// @param id Proposal ID
    function closeProposal(uint256 id) external onlyAdmin {
        require(id > 0 && id <= proposalCount, "RightToRepairGovernanceDAO: Invalid proposal");
        proposals[id].active = false;
        emit ProposalClosed(id, proposals[id].votesFor, proposals[id].votesAgainst);
    }

    /// @notice Initiate admin transfer
    /// @param newAdmin New admin address
    function initiateAdminTransfer(address newAdmin) external onlyAdmin {
        require(newAdmin != address(0), "RightToRepairGovernanceDAO: Invalid address");
        pendingAdmin = newAdmin;
        emit AdminTransferInitiated(newAdmin);
    }

    /// @notice Accept admin transfer
    function acceptAdminTransfer() external {
        require(msg.sender == pendingAdmin, "RightToRepairGovernanceDAO: Not pending admin");
        address oldAdmin = admin;
        admin = pendingAdmin;
        pendingAdmin = address(0);
        emit AdminTransferred(oldAdmin, admin);
    }

    /// @notice Get proposal details
    /// @param id Proposal ID
    function getProposal(uint256 id) external view returns (Proposal memory) {
        require(id > 0 && id <= proposalCount, "RightToRepairGovernanceDAO: Invalid proposal");
        return proposals[id];
    }
}
