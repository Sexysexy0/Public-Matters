// GlobalLaborJusticeDAO.sol
pragma solidity ^0.8.0;

contract GlobalLaborJusticeDAO {
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

    // Worker dignity records
    mapping(address => uint256) public weeklyAttendance;
    mapping(address => uint256) public weeklyAbsences;
    mapping(address => uint256) public dailyWorkload;
    mapping(address => bool) public absorbedDirectly; // bypass agency

    event ProposalCreated(uint256 id, string description);
    event Voted(address indexed worker, uint256 proposalId, bool support);
    event ProposalExecuted(uint256 id, string description);
    event WorkerAbsorbed(address indexed worker, string message);
    event BreaktimeScheduled(address indexed worker, uint256 duration);
    event AbsenceRecorded(address indexed worker, uint256 count);
    event OverloadDetected(address indexed worker, string message);
    event IncentiveGranted(address indexed worker, string reward);

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

    // --- Direct Employment (Agency Absorption) ---
    function absorbWorker(address worker) public {
        absorbedDirectly[worker] = true;
        emit WorkerAbsorbed(worker, "Worker absorbed directly by company, bypassing agency.");
    }

    // --- Breaktime Autonomy ---
    function scheduleBreak(address worker, uint256 duration) public {
        emit BreaktimeScheduled(worker, duration);
    }

    // --- Absence Neutrality ---
    function recordAbsence(address worker) public {
        weeklyAbsences[worker] += 1;
        emit AbsenceRecorded(worker, weeklyAbsences[worker]);

        if (weeklyAbsences[worker] == 2) {
            emit ProposalExecuted(0, "Encouragement only: We value you, take care.");
        }
    }

    // --- Workload Balance ---
    function recordWorkload(address worker, uint256 workload) public {
        dailyWorkload[worker] = workload;
        if (workload > 8) {
            emit OverloadDetected(worker, "Workload heavy, redistribute tasks.");
        }
    }

    // --- Attendance Rewards ---
    function recordAttendance(address worker) public {
        weeklyAttendance[worker] += 1;
    }

    function grantIncentive(address worker) public {
        if (weeklyAttendance[worker] >= 5) {
            emit IncentiveGranted(worker, "Weekly attendance complete: reward granted.");
        }
    }

    function resetWeek(address worker) public {
        weeklyAttendance[worker] = 0;
        weeklyAbsences[worker] = 0;
    }
}
