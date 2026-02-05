// InnovationNarrativeDAO.sol
pragma solidity ^0.8.0;

contract InnovationNarrativeDAO {
    struct Proposal {
        uint256 id;
        string theme;   // e.g. "AI + Blockchain", "Green Finance"
        string narrative;
        uint256 votesFor;
        uint256 votesAgainst;
        bool enacted;
    }

    uint256 public proposalCount;
    mapping(uint256 => Proposal) public proposals;

    event ProposalCreated(uint256 id, string theme, string narrative);
    event ProposalVoted(uint256 id, string theme, bool support);
    event ProposalEnacted(uint256 id, string theme);
    event NarrativeDeclared(string message);

    function createProposal(string memory theme, string memory narrative) public {
        proposalCount++;
        proposals[proposalCount] = Proposal(proposalCount, theme, narrative, 0, 0, false);
        emit ProposalCreated(proposalCount, theme, narrative);
    }

    function voteProposal(uint256 id, bool support) public {
        if (support) {
            proposals[id].votesFor++;
        } else {
            proposals[id].votesAgainst++;
        }
        emit ProposalVoted(id, proposals[id].theme, support);
    }

    function enactProposal(uint256 id) public {
        Proposal storage p = proposals[id];
        require(!p.enacted, "Already enacted");
        require(p.votesFor > p.votesAgainst, "Not enough support");
        p.enacted = true;
        emit ProposalEnacted(p.id, p.theme);
    }

    function declareNarrative() public {
        emit NarrativeDeclared("Innovation Narrative DAO: storytelling arcs encoded into communal consequence.");
    }
}
