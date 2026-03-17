// GlobalCryptoJusticeDAO.sol
pragma solidity ^0.8.0;

contract GlobalCryptoJusticeDAO {
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

    // --- Risk Records ---
    mapping(address => uint256) public leverageRatio;
    mapping(address => uint256) public activeAddresses;
    mapping(uint256 => int256) public dailyETFFlows;

    event ProposalCreated(uint256 id, string description);
    event Voted(address indexed member, uint256 proposalId, bool support);
    event ProposalExecuted(uint256 id, string description);

    event LeverageRecorded(address indexed trader, uint256 ratio);
    event ActivityRecorded(address indexed network, uint256 activeUsers);
    event ETFFlowRecorded(uint256 day, int256 flow);
    event BreachReported(string ecosystem, uint256 loss);

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

    // --- Risk Monitoring ---
    function recordLeverage(address trader, uint256 ratio) public {
        leverageRatio[trader] = ratio;
        emit LeverageRecorded(trader, ratio);
    }

    function recordActivity(address network, uint256 activeUsers) public {
        activeAddresses[network] = activeUsers;
        emit ActivityRecorded(network, activeUsers);
    }

    function recordETFFlow(uint256 day, int256 flow) public {
        dailyETFFlows[day] = flow;
        emit ETFFlowRecorded(day, flow);
    }

    function reportBreach(string memory ecosystem, uint256 loss) public {
        emit BreachReported(ecosystem, loss);
    }
}
