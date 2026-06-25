// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title TakedownGovernanceDAO
/// @notice Secure governance DAO with proper access control and vote tracking
contract TakedownGovernanceDAO {
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
    mapping(address => bool) public governors;

    event ProposalCreated(uint256 indexed id, string topic, uint256 timestamp);
    event Voted(uint256 indexed id, address indexed voter, bool support);
    event ProposalClosed(uint256 indexed id, uint256 votesFor, uint256 votesAgainst);
    event GovernorAdded(address indexed governor);
    event GovernorRemoved(address indexed governor);
    event AdminTransferInitiated(address indexed newAdmin);
    event AdminTransferred(address indexed oldAdmin, address indexed newAdmin);

    modifier onlyAdmin() {
        require(msg.sender == admin, "TakedownGovernanceDAO: Only admin");
        _;
    }

    modifier validInput(string memory _str) {
        require(bytes(_str).length > 0, "TakedownGovernanceDAO: Input empty");
        require(bytes(_str).length <= 256, "TakedownGovernanceDAO: Input too long");
        _;
    }

    constructor() {
        admin = msg.sender;
        governors[msg.sender] = true;
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
        require(id > 0 && id <= proposalCount, "TakedownGovernanceDAO: Invalid proposal");
        require(proposals[id].active, "TakedownGovernanceDAO: Proposal inactive");
        require(governors[msg.sender], "TakedownGovernanceDAO: Not governor");
        require(!hasVoted[id][msg.sender], "TakedownGovernanceDAO: Already voted");

        hasVoted[id][msg.sender] = true;

        if (support) {
            proposals[id].votesFor++;
        } else {
            proposals[id].votesAgainst++;
        }

        emit Voted(id, msg.sender, support);
    }

    /// @notice Add governor
    /// @param governor Address to add
    function addGovernor(address governor) external onlyAdmin {
        require(governor != address(0), "TakedownGovernanceDAO: Invalid address");
        governors[governor] = true;
        emit GovernorAdded(governor);
    }

    /// @notice Remove governor
    /// @param governor Address to remove
    function removeGovernor(address governor) external onlyAdmin {
        governors[governor] = false;
        emit GovernorRemoved(governor);
    }

    /// @notice Close proposal
    /// @param id Proposal ID
    function closeProposal(uint256 id) external onlyAdmin {
        require(id > 0 && id <= proposalCount, "TakedownGovernanceDAO: Invalid proposal");
        proposals[id].active = false;
        emit ProposalClosed(id, proposals[id].votesFor, proposals[id].votesAgainst);
    }

    /// @notice Initiate admin transfer
    /// @param newAdmin New admin address
    function initiateAdminTransfer(address newAdmin) external onlyAdmin {
        require(newAdmin != address(0), "TakedownGovernanceDAO: Invalid address");
        pendingAdmin = newAdmin;
        emit AdminTransferInitiated(newAdmin);
    }

    /// @notice Accept admin transfer
    function acceptAdminTransfer() external {
        require(msg.sender == pendingAdmin, "TakedownGovernanceDAO: Not pending");
        address oldAdmin = admin;
        admin = pendingAdmin;
        pendingAdmin = address(0);
        emit AdminTransferred(oldAdmin, admin);
    }

    /// @notice Get proposal details
    /// @param id Proposal ID
    function getProposal(uint256 id) external view returns (Proposal memory) {
        require(id > 0 && id <= proposalCount, "TakedownGovernanceDAO: Invalid proposal");
        return proposals[id];
    }
}
