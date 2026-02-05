// DecentralizedConsensusProtocol.sol
pragma solidity ^0.8.0;

contract DecentralizedConsensusProtocol {
    struct Proposal {
        uint256 id;
        string topic;   // e.g. "Block Size", "Protocol Upgrade"
        uint256 votesFor;
        uint256 votesAgainst;
        bool accepted;
    }

    uint256 public proposalCount;
    mapping(uint256 => Proposal) public proposals;

    event ProposalCreated(uint256 id, string topic);
    event ProposalVoted(uint256 id, string topic, bool support);
    event ProposalAccepted(uint256 id, string topic);
    event ConsensusDeclared(string message);

    function createProposal(string memory topic) public {
        proposalCount++;
        proposals[proposalCount] = Proposal(proposalCount, topic, 0, 0, false);
        emit ProposalCreated(proposalCount, topic);
    }

    function voteProposal(uint256 id, bool support) public {
        if (support) {
            proposals[id].votesFor++;
        } else {
            proposals[id].votesAgainst++;
        }
        emit ProposalVoted(id, proposals[id].topic, support);
    }

    function acceptProposal(uint256 id) public {
        Proposal storage p = proposals[id];
        require(!p.accepted, "Already accepted");
        require(p.votesFor > p.votesAgainst, "Not enough support");
        p.accepted = true;
        emit ProposalAccepted(p.id, p.topic);
    }

    function declareConsensus() public {
        emit ConsensusDeclared("Decentralized Consensus Protocol: decision arcs encoded into communal dignity.");
    }
}
