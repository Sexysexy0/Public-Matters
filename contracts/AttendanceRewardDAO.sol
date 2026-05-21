// AttendanceRewardDAO.sol
pragma solidity ^0.8.0;

contract AttendanceRewardDAO {
    struct Proposal {
        uint256 id;
        string rewardType; // e.g. "Cash Bonus", "Extra Day Off", "Recognition"
        uint256 votesFor;
        uint256 votesAgainst;
        bool executed;
    }

    mapping(uint256 => Proposal) public proposals;
    mapping(address => mapping(uint256 => bool)) public hasVoted;
    mapping(address => uint256) public weeklyAttendance;
    uint256 public proposalCount;

    event ProposalCreated(uint256 id, string rewardType);
    event Voted(address indexed worker, uint256 proposalId, bool support);
    event ProposalExecuted(uint256 id, string rewardType);
    event IncentiveGranted(address indexed worker, string rewardType);

    // Workers log attendance
    function recordAttendance(address worker) public {
        weeklyAttendance[worker] += 1;
    }

    // Create reward proposal
    function createProposal(string memory rewardType) public {
        proposalCount++;
        proposals[proposalCount] = Proposal(proposalCount, rewardType, 0, 0, false);
        emit ProposalCreated(proposalCount, rewardType);
    }

    // Vote on reward proposals
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

    // Execute proposal if majority supports
    function executeProposal(uint256 proposalId) public {
        Proposal storage p = proposals[proposalId];
        require(!p.executed, "Already executed");
        require(p.votesFor > p.votesAgainst, "Not enough support");

        p.executed = true;
        emit ProposalExecuted(proposalId, p.rewardType);
    }

    // Grant incentive if attendance complete (5 days)
    function grantIncentive(address worker, uint256 proposalId) public {
        if (weeklyAttendance[worker] >= 5 && proposals[proposalId].executed) {
            emit IncentiveGranted(worker, proposals[proposalId].rewardType);
        }
    }

    // Reset weekly attendance
    function resetWeek(address worker) public {
        weeklyAttendance[worker] = 0;
    }
}
