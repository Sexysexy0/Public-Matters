tt// InvestorDAO.sol
pragma solidity ^0.8.0;

contract InvestorDAO {
    struct Proposal {
        uint256 id;
        string asset;     // e.g. "BTC"
        string strategy;  // e.g. "Long-term Hold"
        uint256 votesFor;
        uint256 votesAgainst;
        bool ratified;
    }

    uint256 public proposalCount;
    mapping(uint256 => Proposal) public proposals;

    event ProposalCreated(uint256 id, string asset, string strategy);
    event ProposalVoted(uint256 id, string asset, bool support);
    event ProposalRatified(uint256 id, string asset);
    event InvestorDeclared(string message);

    function createProposal(string memory asset, string memory strategy) public {
        proposalCount++;
        proposals[proposalCount] = Proposal(proposalCount, asset, strategy, 0, 0, false);
        emit ProposalCreated(proposalCount, asset, strategy);
    }

    function voteProposal(uint256 id, bool support) public {
        if (support) {
            proposals[id].votesFor++;
        } else {
            proposals[id].votesAgainst++;
        }
        emit ProposalVoted(id, proposals[id].asset, support);
    }

    function ratifyProposal(uint256 id) public {
        Proposal storage p = proposals[id];
        require(!p.ratified, "Already ratified");
        require(p.votesFor > p.votesAgainst, "Not enough support");
        p.ratified = true;
        emit ProposalRatified(p.id, p.asset);
    }

    function declareInvestor() public {
        emit InvestorDeclared("Investor DAO: safeguard arcs encoded into communal consequence.");
    }
}
