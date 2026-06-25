// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title OptionGovernanceDAO
/// @notice Secure governance DAO for option-based decisions with duplicate vote prevention
contract OptionGovernanceDAO {
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
    mapping(address => bool) public participants;

    event ProposalCreated(uint256 indexed id, string topic, uint256 timestamp);
    event Voted(uint256 indexed id, address indexed voter, bool support);
    event ProposalClosed(uint256 indexed id, uint256 votesFor, uint256 votesAgainst);
    event ParticipantAdded(address indexed participant);
    event ParticipantRemoved(address indexed participant);
    event AdminTransferInitiated(address indexed newAdmin);
    event AdminTransferred(address indexed oldAdmin, address indexed newAdmin);

    modifier onlyAdmin() {
        require(msg.sender == admin, "OptionGovernanceDAO: Only admin");
        _;
    }

    modifier validInput(string memory _str) {
        require(bytes(_str).length > 0, "OptionGovernanceDAO: Input empty");
        require(bytes(_str).length <= 256, "OptionGovernanceDAO: Input too long");
        _;
    }

    constructor() {
        admin = msg.sender;
        participants[msg.sender] = true;
    }

    /// @notice Create a proposal
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

    /// @notice Vote on proposal
    /// @param id Proposal ID
    /// @param support True for yes, false for no
    function vote(uint256 id, bool support) external {
        require(id > 0 && id <= proposalCount, "OptionGovernanceDAO: Invalid proposal");
        require(proposals[id].active, "OptionGovernanceDAO: Proposal inactive");
        require(participants[msg.sender], "OptionGovernanceDAO: Not participant");
        require(!hasVoted[id][msg.sender], "OptionGovernanceDAO: Already voted");

        hasVoted[id][msg.sender] = true;

        if (support) {
            proposals[id].votesFor++;
        } else {
            proposals[id].votesAgainst++;
        }

        emit Voted(id, msg.sender, support);
    }

    /// @notice Add participant
    /// @param participant Address to add
    function addParticipant(address participant) external onlyAdmin {
        require(participant != address(0), "OptionGovernanceDAO: Invalid address");
        participants[participant] = true;
        emit ParticipantAdded(participant);
    }

    /// @notice Remove participant
    /// @param participant Address to remove
    function removeParticipant(address participant) external onlyAdmin {
        participants[participant] = false;
        emit ParticipantRemoved(participant);
    }

    /// @notice Close proposal
    /// @param id Proposal ID
    function closeProposal(uint256 id) external onlyAdmin {
        require(id > 0 && id <= proposalCount, "OptionGovernanceDAO: Invalid proposal");
        proposals[id].active = false;
        emit ProposalClosed(id, proposals[id].votesFor, proposals[id].votesAgainst);
    }

    /// @notice Initiate admin transfer
    /// @param newAdmin New admin address
    function initiateAdminTransfer(address newAdmin) external onlyAdmin {
        require(newAdmin != address(0), "OptionGovernanceDAO: Invalid address");
        pendingAdmin = newAdmin;
        emit AdminTransferInitiated(newAdmin);
    }

    /// @notice Accept admin transfer
    function acceptAdminTransfer() external {
        require(msg.sender == pendingAdmin, "OptionGovernanceDAO: Not pending");
        address oldAdmin = admin;
        admin = pendingAdmin;
        pendingAdmin = address(0);
        emit AdminTransferred(oldAdmin, admin);
    }

    /// @notice Get proposal details
    /// @param id Proposal ID
    function getProposal(uint256 id) external view returns (Proposal memory) {
        require(id > 0 && id <= proposalCount, "OptionGovernanceDAO: Invalid proposal");
        return proposals[id];
    }
}
