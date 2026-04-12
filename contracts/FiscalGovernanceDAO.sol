// FiscalGovernanceDAO.sol
pragma solidity ^0.8.0;

contract FiscalGovernanceDAO {
    struct Proposal {
        uint256 id;
        string topic;       // e.g. "Oversight of fiscal governance and fair taxation safeguards"
        uint256 votesFor;
        uint256 votesAgainst;
        bool active;
    }

    uint256 public proposalCount;
    mapping(uint256 => Proposal) public proposals;

    event ProposalCreated(uint256 id, string topic);
    event Voted(uint256 id, string side);

    function createProposal(string memory topic) public {
        proposalCount++;
        proposals[proposalCount] = Proposal(proposalCount, topic, 0, 0, true);
        emit ProposalCreated(proposalCount, topic);
    }

    function vote(uint256 id, bool support) public {
        require(proposals[id].active, "Proposal not active");
        if (support) {
            proposals[id].votesFor++;
            emit Voted(id, "For");
        } else {
            proposals[id].votesAgainst++;
            emit Voted(id, "Against");
        }
    }
}
