// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CommunityDAO {
    struct Proposal {
        string description;
        uint256 voteCount;
        uint256 againstCount;
        uint256 deadline;
        bool executed;
        address proposer;
    }

    mapping(uint256 => Proposal) public proposals;
    mapping(address => bool) public isMember;
    mapping(uint256 => mapping(address => bool)) public hasVoted;

    uint256 public proposalCount;
    uint256 public quorum = 1000; // minimum votes needed

    event ProposalCreated(uint256 indexed id, string description, address proposer);
    event Voted(uint256 indexed id, address voter, bool support);
    event ProposalExecuted(uint256 indexed id);

    constructor(address[] memory _initialMembers) {
        for (uint i = 0; i < _initialMembers.length; i++) {
            isMember[_initialMembers[i]] = true;
        }
    }

    function addMember(address _member) external {
        // onlyOwner placeholder
        isMember[_member] = true;
    }

    function createProposal(string memory _description) external {
        require(isMember[msg.sender], "Not a member");
        proposalCount++;
        proposals[proposalCount] = Proposal({
            description: _description,
            voteCount: 0,
            againstCount: 0,
            deadline: block.timestamp + 7 days,
            executed: false,
            proposer: msg.sender
        });
        emit ProposalCreated(proposalCount, _description, msg.sender);
    }

    function vote(uint256 _proposalId, bool _support) external {
        require(isMember[msg.sender], "Not a member");
        require(!hasVoted[_proposalId][msg.sender], "Already voted");
        require(block.timestamp < proposals[_proposalId].deadline, "Voting ended");

        hasVoted[_proposalId][msg.sender] = true;
        if (_support) {
            proposals[_proposalId].voteCount++;
        } else {
            proposals[_proposalId].againstCount++;
        }
        emit Voted(_proposalId, msg.sender, _support);
    }

    function executeProposal(uint256 _proposalId) external {
        Proposal storage proposal = proposals[_proposalId];
        require(!proposal.executed, "Already executed");
        require(block.timestamp > proposal.deadline, "Voting not ended");
        require(proposal.voteCount + proposal.againstCount >= quorum, "Quorum not met");

        proposal.executed = true;
        emit ProposalExecuted(_proposalId);
    }

    function getProposal(uint256 _proposalId) external view returns (Proposal memory) {
        return proposals[_proposalId];
    }
}
