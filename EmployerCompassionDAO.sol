// EmployerCompassionDAO.sol
pragma solidity ^0.8.0;

contract EmployerCompassionDAO {
    struct Proposal {
        uint256 id;
        string description;
        uint256 votesFor;
        uint256 votesAgainst;
        bool executed;
    }

    mapping(uint256 => Proposal) public proposals;
    mapping(address => mapping(uint256 => bool)) public hasVoted;
    uint256 public proposalCount;

    // Employer traits record
    mapping(address => string) public employerTraits;

    event ProposalCreated(uint256 id, string description);
    event Voted(address indexed worker, uint256 proposalId, bool support);
    event ProposalExecuted(uint256 id, string description);
    event EmployerTraitsDeclared(address indexed employer, string traits);

    // --- Governance ---
    function createProposal(string memory description) public {
        proposalCount++;
        proposals[proposalCount] = Proposal(proposalCount, description, 0, 0, false);
        emit ProposalCreated(proposalCount, description);
    }

    function vote(uint256 proposalId, bool support) public {
        require(!hasVoted[msg.sender][proposalId], "Already voted");
        hasVoted[msg.sender][proposalId] = true;

        if (support) {
            proposals[proposalId].votesFor++;
        } else {
            proposals[proposalId].votesAgainst++;
        }

        emit Voted(msg.sender, proposalId, support);
    }

    function executeProposal(uint256 proposalId) public {
        Proposal storage p = proposals[proposalId];
        require(!p.executed, "Already executed");
        require(p.votesFor > p.votesAgainst, "Not enough support");

        p.executed = true;
        emit ProposalExecuted(proposalId, p.description);
    }

    // --- Employer Traits Declaration ---
    function declareTraits(address employer, string memory traits) public {
        employerTraits[employer] = traits;
        emit EmployerTraitsDeclared(employer, traits);
    }
}
