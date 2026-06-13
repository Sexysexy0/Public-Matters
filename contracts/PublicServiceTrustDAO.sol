// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title PublicServiceTrustDAO
/// @notice DAO covenant for participatory governance of service delivery accountability
contract PublicServiceTrustDAO {
    address public oversightCommittee;
    uint256 public proposalCount;

    struct ServiceProposal {
        uint256 id;
        string service;     // e.g. healthcare, education, infrastructure
        string safeguard;   // transparency, fairness, accountability
        string notes;       // contextual application
        uint256 votesFor;
        uint256 votesAgainst;
        bool resolved;
        uint256 timestamp;
    }

    mapping(uint256 => ServiceProposal) public proposals;
    mapping(address => mapping(uint256 => bool)) public voted;

    event ProposalCreated(uint256 indexed id, string service, string safeguard, string notes);
    event Voted(uint256 indexed id, address voter, bool support);
    event ProposalResolved(uint256 indexed id, string service, bool passed);

    modifier onlyOversight() {
        require(msg.sender == oversightCommittee, "Not authorized");
        _;
    }

    constructor(address _oversightCommittee) {
        oversightCommittee = _oversightCommittee;
    }

    /// @notice Oversight creates service accountability proposal
    function createProposal(string calldata service, string calldata safeguard, string calldata notes) external onlyOversight {
        proposalCount++;
        proposals[proposalCount] = ServiceProposal({
            id: proposalCount,
            service: service,
            safeguard: safeguard,
            notes: notes,
            votesFor: 0,
            votesAgainst: 0,
            resolved: false,
            timestamp: block.timestamp
        });
        emit ProposalCreated(proposalCount, service, safeguard, notes);
    }

    /// @notice Citizens vote on service accountability proposal
    function vote(uint256 id, bool support) external {
        require(!voted[msg.sender][id], "Already voted");
        require(!proposals[id].resolved, "Proposal resolved");

        voted[msg.sender][id] = true;
        if (support) {
            proposals[id].votesFor++;
        } else {
            proposals[id].votesAgainst++;
        }
        emit Voted(id, msg.sender, support);
    }

    /// @notice Oversight resolves service accountability proposal
    function resolveProposal(uint256 id) external onlyOversight {
        ServiceProposal storage p = proposals[id];
        require
