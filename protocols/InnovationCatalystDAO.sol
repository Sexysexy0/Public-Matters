// InnovationCatalystDAO.sol
pragma solidity ^0.8.0;

contract InnovationCatalystDAO {
    struct Proposal {
        uint256 id;
        string catalyst;   // e.g. "AI + Blockchain", "Green Tech"
        string description;
        uint256 votesFor;
        uint256 votesAgainst;
        bool enacted;
    }

    uint256 public proposalCount;
    mapping(uint256 => Proposal) public proposals;

    event ProposalCreated(uint256 id, string catalyst, string description);
    event ProposalVoted(uint256 id, string catalyst, bool support);
    event ProposalEnacted(uint256 id, string catalyst);
    event CatalystDeclared(string message);

    function createProposal(string memory catalyst, string memory description) public {
        proposalCount++;
        proposals[proposalCount] = Proposal(proposalCount, catalyst, description, 0, 0, false);
        emit ProposalCreated(proposalCount, catalyst, description);
    }

    function voteProposal(uint256 id, bool support) public {
        if (support) {
            proposals[id].votesFor++;
        } else {
            proposals[id].votesAgainst++;
        }
        emit ProposalVoted(id, proposals[id].catalyst, support);
    }

    function enactProposal(uint256 id) public {
        Proposal storage p = proposals[id];
        require(!p.enacted, "Already enacted");
        require(p.votesFor > p.votesAgainst, "Not enough support");
        p.enacted = true;
        emit ProposalEnacted(p.id, p.catalyst);
    }

    function declareCatalyst() public {
        emit CatalystDeclared("Innovation Catalyst DAO: spark arcs encoded into communal consequence.");
    }
}
