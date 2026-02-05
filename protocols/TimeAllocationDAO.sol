// TimeAllocationDAO.sol
pragma solidity ^0.8.0;

contract TimeAllocationDAO {
    struct Proposal {
        uint256 id;
        string horizon;   // e.g. "Short-term", "Long-term"
        uint256 targetPercentage;
        uint256 votesFor;
        uint256 votesAgainst;
        bool enacted;
    }

    uint256 public proposalCount;
    mapping(uint256 => Proposal) public proposals;

    event ProposalCreated(uint256 id, string horizon, uint256 targetPercentage);
    event ProposalVoted(uint256 id, string horizon, bool support);
    event ProposalEnacted(uint256 id, string horizon);
    event AllocationDeclared(string message);

    function createProposal(string memory horizon, uint256 targetPercentage) public {
        proposalCount++;
        proposals[proposalCount] = Proposal(proposalCount, horizon, targetPercentage, 0, 0, false);
        emit ProposalCreated(proposalCount, horizon, targetPercentage);
    }

    function voteProposal(uint256 id, bool support) public {
        if (support) {
            proposals[id].votesFor++;
        } else {
            proposals[id].votesAgainst++;
        }
        emit ProposalVoted(id, proposals[id].horizon, support);
    }

    function enactProposal(uint256 id) public {
        Proposal storage p = proposals[id];
        require(!p.enacted, "Already enacted");
        require(p.votesFor > p.votesAgainst, "Not enough support");
        p.enacted = true;
        emit ProposalEnacted(p.id, p.horizon);
    }

    function declareAllocation() public {
        emit AllocationDeclared("Time Allocation DAO: balance arcs encoded into communal consequence.");
    }
}
