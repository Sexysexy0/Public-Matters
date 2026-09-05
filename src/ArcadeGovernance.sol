// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ArcadeGovernance
/// @notice Gamified voting system: bawat proposal ay parang "level"
contract ArcadeGovernance {
    struct Proposal {
        uint256 id;
        string description;
        uint256 votesFor;
        uint256 votesAgainst;
        bool executed;
    }

    mapping(uint256 => Proposal) public proposals;
    uint256 public nextProposalId;

    event ProposalCreated(uint256 id, string description);
    event Voted(uint256 id, address voter, bool support);
    event Executed(uint256 id);

    function createProposal(string memory description) external {
        proposals[nextProposalId] = Proposal(nextProposalId, description, 0, 0, false);
        emit ProposalCreated(nextProposalId, description);
        nextProposalId++;
    }

    function vote(uint256 id, bool support) external {
        Proposal storage p = proposals[id];
        require(!p.executed, "Already executed");
        if (support) {
            p.votesFor++;
        } else {
            p.votesAgainst++;
        }
        emit Voted(id, msg.sender, support);
    }

    function execute(uint256 id) external {
        Proposal storage p = proposals[id];
        require(!p.executed, "Already executed");
        require(p.votesFor > p.votesAgainst, "Game Over");
        p.executed = true;
        emit Executed(id);
    }
}
