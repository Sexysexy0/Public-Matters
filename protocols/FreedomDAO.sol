// FreedomDAO.sol
pragma solidity ^0.8.0;

contract FreedomDAO {
    struct Proposal {
        uint256 id;
        string focus;     // e.g. "Open Source Firmware"
        string proposer;  // e.g. "Community Dev"
        uint256 votesFor;
        uint256 votesAgainst;
        bool ratified;
    }

    uint256 public proposalCount;
    mapping(uint256 => Proposal) public proposals;

    event ProposalCreated(uint256 id, string focus, string proposer);
    event ProposalVoted(uint256 id, string focus, bool support);
    event ProposalRatified(uint256 id, string focus);
    event FreedomDeclared(string message);

    function createProposal(string memory focus, string memory proposer) public {
        proposalCount++;
        proposals[proposalCount] = Proposal(proposalCount, focus, proposer, 0, 0, false);
        emit ProposalCreated(proposalCount, focus, proposer);
    }

    function voteProposal(uint256 id, bool support) public {
        if (support) {
            proposals[id].votesFor++;
        } else {
            proposals[id].votesAgainst++;
        }
        emit ProposalVoted(id, proposals[id].focus, support);
    }

    function ratifyProposal(uint256 id) public {
        Proposal storage p = proposals[id];
        require(!p.ratified, "Already ratified");
        require(p.votesFor > p.votesAgainst, "Not enough support");
        p.ratified = true;
        emit ProposalRatified(p.id, p.focus);
    }

    function declareFreedom() public {
        emit FreedomDeclared("Freedom DAO: safeguard arcs encoded into communal consequence.");
    }
}
