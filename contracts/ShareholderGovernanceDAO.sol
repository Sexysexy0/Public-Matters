// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ShareholderGovernanceDAO
/// @notice Secure shareholder voting DAO with duplicate prevention
contract ShareholderGovernanceDAO {
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
    mapping(address => bool) public shareholders;

    event ProposalCreated(uint256 indexed id, string topic, uint256 timestamp);
    event Voted(uint256 indexed id, address indexed voter, bool support);
    event ProposalClosed(uint256 indexed id, uint256 votesFor, uint256 votesAgainst);
    event ShareholderAdded(address indexed shareholder);
    event ShareholderRemoved(address indexed shareholder);
    event AdminTransferInitiated(address indexed newAdmin);
    event AdminTransferred(address indexed oldAdmin, address indexed newAdmin);

    modifier onlyAdmin() {
        require(msg.sender == admin, "ShareholderGovernanceDAO: Only admin");
        _;
    }

    modifier validInput(string memory _str) {
        require(bytes(_str).length > 0, "ShareholderGovernanceDAO: Input empty");
        require(bytes(_str).length <= 256, "ShareholderGovernanceDAO: Input too long");
        _;
    }

    constructor() {
        admin = msg.sender;
        shareholders[msg.sender] = true;
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
        require(id > 0 && id <= proposalCount, "ShareholderGovernanceDAO: Invalid proposal");
        require(proposals[id].active, "ShareholderGovernanceDAO: Proposal inactive");
        require(shareholders[msg.sender], "ShareholderGovernanceDAO: Not shareholder");
        require(!hasVoted[id][msg.sender], "ShareholderGovernanceDAO: Already voted");

        hasVoted[id][msg.sender] = true;

        if (support) {
            proposals[id].votesFor++;
        } else {
            proposals[id].votesAgainst++;
        }

        emit Voted(id, msg.sender, support);
    }

    /// @notice Add shareholder
    /// @param shareholder Address to add
    function addShareholder(address shareholder) external onlyAdmin {
        require(shareholder != address(0), "ShareholderGovernanceDAO: Invalid address");
        shareholders[shareholder] = true;
        emit ShareholderAdded(shareholder);
    }

    /// @notice Remove shareholder
    /// @param shareholder Address to remove
    function removeShareholder(address shareholder) external onlyAdmin {
        shareholders[shareholder] = false;
        emit ShareholderRemoved(shareholder);
    }

    /// @notice Close proposal
    /// @param id Proposal ID
    function closeProposal(uint256 id) external onlyAdmin {
        require(id > 0 && id <= proposalCount, "ShareholderGovernanceDAO: Invalid proposal");
        proposals[id].active = false;
        emit ProposalClosed(id, proposals[id].votesFor, proposals[id].votesAgainst);
    }

    /// @notice Initiate admin transfer
    /// @param newAdmin New admin address
    function initiateAdminTransfer(address newAdmin) external onlyAdmin {
        require(newAdmin != address(0), "ShareholderGovernanceDAO: Invalid address");
        pendingAdmin = newAdmin;
        emit AdminTransferInitiated(newAdmin);
    }

    /// @notice Accept admin transfer
    function acceptAdminTransfer() external {
        require(msg.sender == pendingAdmin, "ShareholderGovernanceDAO: Not pending");
        address oldAdmin = admin;
        admin = pendingAdmin;
        pendingAdmin = address(0);
        emit AdminTransferred(oldAdmin, admin);
    }

    /// @notice Get proposal details
    /// @param id Proposal ID
    function getProposal(uint256 id) external view returns (Proposal memory) {
        require(id > 0 && id <= proposalCount, "ShareholderGovernanceDAO: Invalid proposal");
        return proposals[id];
    }
}
