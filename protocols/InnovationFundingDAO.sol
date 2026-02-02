// InnovationFundingDAO.sol
pragma solidity ^0.8.0;

contract InnovationFundingDAO {
    struct Proposal {
        uint256 id;
        string idea;   // e.g. "GenAI Deployment", "Climate Tech"
        uint256 requestedFunds;
        uint256 votesFor;
        uint256 votesAgainst;
        bool approved;
    }

    uint256 public proposalCount;
    mapping(uint256 => Proposal) public proposals;

    event ProposalCreated(uint256 id, string idea, uint256 requestedFunds);
    event ProposalVoted(uint256 id, string idea, bool support);
    event ProposalApproved(uint256 id, string idea);
    event FundingDeclared(string message);

    function createProposal(string memory idea, uint256 requestedFunds) public {
        proposalCount++;
        proposals[proposalCount] = Proposal(proposalCount, idea, requestedFunds, 0, 0, false);
        emit ProposalCreated(proposalCount, idea, requestedFunds);
    }

    function voteProposal(uint256 id, bool support) public {
        if (support) {
            proposals[id].votesFor++;
        } else {
            proposals[id].votesAgainst++;
        }
        emit ProposalVoted(id, proposals[id].idea, support);
    }

    function approveProposal(uint256 id) public {
        Proposal storage p = proposals[id];
        require(!p.approved, "Already approved");
        require(p.votesFor > p.votesAgainst, "Not enough support");
        p.approved = true;
        emit ProposalApproved(p.id, p.idea);
    }

    function declareFunding() public {
        emit FundingDeclared("Innovation Funding DAO: experimentation arcs encoded into communal consequence.");
    }
}
