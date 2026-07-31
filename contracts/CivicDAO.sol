// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./SammaCodex.sol";

contract CivicDAO {
    SammaCodex public codex;
    address public owner;

    struct Proposal {
        uint256 id;
        uint256 principleId;
        string description;
        uint256 votesFor;
        uint256 votesAgainst;
        bool executed;
    }

    uint256 public proposalCount;
    mapping(uint256 => Proposal) public proposals;
    mapping(address => mapping(uint256 => bool)) public hasVoted;

    event ProposalCreated(uint256 indexed id, string description, uint256 principleId);
    event Voted(uint256 indexed proposalId, address indexed voter, bool support);
    event ProposalExecuted(uint256 indexed id);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor(address codexAddress) {
        codex = SammaCodex(codexAddress);
        owner = msg.sender;
    }

    function createProposal(string calldata description, uint256 principleId) external {
        require(codex.isActive(principleId), "Principle not active");
        proposalCount++;
        proposals[proposalCount] = Proposal({
            id: proposalCount,
            principleId: principleId,
            description: description,
            votesFor: 0,
            votesAgainst: 0,
            executed: false
        });
        emit ProposalCreated(proposalCount, description, principleId);
    }

    function vote(uint256 proposalId, bool support) external {
        require(proposalId > 0 && proposalId <= proposalCount, "Proposal does not exist");
        Proposal storage p = proposals[proposalId];
        require(codex.isActive(p.principleId), "Principle not active");
        require(!p.executed, "Proposal already executed");
        require(!hasVoted[msg.sender][proposalId], "Already voted");

        hasVoted[msg.sender][proposalId] = true;
        if (support) {
            p.votesFor++;
        } else {
            p.votesAgainst++;
        }
        emit Voted(proposalId, msg.sender, support);
    }

    function executeProposal(uint256 proposalId) external onlyOwner {
        require(proposalId > 0 && proposalId <= proposalCount, "Proposal does not exist");
        Proposal storage p = proposals[proposalId];
        require(!p.executed, "Already executed");
        
        p.executed = true;
        emit ProposalExecuted(proposalId);
    }
}
