// CommunityDAO.sol
pragma solidity ^0.8.0;

contract CommunityDAO {
    struct Proposal {
        uint256 id;
        string issue;    // e.g. "Utility takeover"
        string proposer; // e.g. "Citizen Group"
        uint256 votesFor;
        uint256 votesAgainst;
        bool resolved;
    }

    uint256 public proposalCount;
    mapping(uint256 => Proposal) public proposals;

    event ProposalCreated(uint256 id, string issue, string proposer);
    event ProposalVoted(uint256 id, string issue, bool support);
    event ProposalResolved(uint256 id, string issue);
    event CommunityDeclared(string message);

    function createProposal(string memory issue, string memory proposer) public {
        proposalCount++;
        proposals[proposalCount] = Proposal(proposalCount, issue, proposer, 0, 0, false);
        emit ProposalCreated(proposalCount, issue, proposer);
    }

    function voteProposal(uint256 id, bool support) public {
        if (support) {
            proposals[id].votesFor++;
        } else {
            proposals[id].votesAgainst++;
        }
        emit ProposalVoted(id, proposals[id].issue, support);
    }

    function resolveProposal(uint256 id) public {
        Proposal storage p = proposals[id];
        require(!p.resolved, "Already resolved");
        require(p.votesFor > p.votesAgainst, "Not enough support");
        p.resolved = true;
        emit ProposalResolved(p.id, p.issue);
    }

    function declareCommunity() public {
        emit CommunityDeclared("Community DAO: safeguard arcs encoded into communal consequence.");
    }
}
