// ETFInflowDAO.sol
pragma solidity ^0.8.0;

contract ETFInflowDAO {
    struct Proposal {
        uint256 id;
        string measure;   // e.g. "Boost BTC ETF inflows", "Reverse ETH outflows"
        uint256 votesFor;
        uint256 votesAgainst;
        bool enacted;
    }

    uint256 public proposalCount;
    mapping(uint256 => Proposal) public proposals;

    event ProposalCreated(uint256 id, string measure);
    event ProposalVoted(uint256 id, string measure, bool support);
    event ProposalEnacted(uint256 id, string measure);
    event InflowDeclared(string message);

    function createProposal(string memory measure) public {
        proposalCount++;
        proposals[proposalCount] = Proposal(proposalCount, measure, 0, 0, false);
        emit ProposalCreated(proposalCount, measure);
    }

    function voteProposal(uint256 id, bool support) public {
        if (support) {
            proposals[id].votesFor++;
        } else {
            proposals[id].votesAgainst++;
        }
        emit ProposalVoted(id, proposals[id].measure, support);
    }

    function enactProposal(uint256 id) public {
        Proposal storage p = proposals[id];
        require(!p.enacted, "Already enacted");
        require(p.votesFor > p.votesAgainst, "Not enough support");
        p.enacted = true;
        emit ProposalEnacted(p.id, p.measure);
    }

    function declareInflow() public {
        emit InflowDeclared("ETF Inflow DAO: institutional arcs encoded into communal resonance.");
    }
}
