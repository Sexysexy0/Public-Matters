// PlanetaryResilienceUnion.sol
pragma solidity ^0.8.0;

contract PlanetaryResilienceUnion {
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

    mapping(address => bool) public unionMembers;
    mapping(address => uint256) public resilienceScore;

    event ProposalCreated(uint256 id, string description);
    event Voted(address indexed member, uint256 proposalId, bool support);
    event ProposalExecuted(uint256 id, string description);
    event MemberJoined(address indexed worker, string message);
    event SolidarityDeclared(string message);
    event ResilienceRecorded(address indexed member, uint256 score);

    function createProposal(string memory description) public {
        proposalCount++;
        proposals[proposalCount] = Proposal(proposalCount, description, 0, 0, false);
        emit ProposalCreated(proposalCount, description);
    }

    function vote(uint256 proposalId, bool support) public {
        require(unionMembers[msg.sender], "Only union members can vote");
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
        emit ProposalExecuted(p.id, p.description);
    }

    function joinUnion(address worker) public {
        unionMembers[worker] = true;
        emit MemberJoined(worker, "Worker joined Planetary Resilience Union.");
    }

    function declareSolidarity() public {
        emit SolidarityDeclared("Global solidarity: workers, traders, communities united against exploitation and shocks.");
    }

    function recordResilience(address member, uint256 score) public {
        resilienceScore[member] = score;
        emit ResilienceRecorded(member, score);
    }
}
