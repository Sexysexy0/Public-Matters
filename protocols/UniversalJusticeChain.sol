// UniversalJusticeChain.sol
pragma solidity ^0.8.0;

contract UniversalJusticeChain {
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

    // Core dignity records
    mapping(address => bool) public directEmployment;
    mapping(address => bool) public equalRights;
    mapping(address => uint256) public workloadBalance;
    mapping(address => uint256) public attendanceScore;
    mapping(address => string) public employerTraits;

    event ProposalCreated(uint256 id, string description);
    event Voted(address indexed member, uint256 proposalId, bool support);
    event ProposalExecuted(uint256 id, string description);

    event WorkerAbsorbed(address indexed worker, string message);
    event RightsGranted(address indexed worker, string message);
    event WorkloadRecorded(address indexed worker, uint256 workload);
    event AttendanceRecorded(address indexed worker, uint256 score);
    event EmployerTraitsDeclared(address indexed employer, string traits);
    event SolidarityDeclared(string message);

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
        emit ProposalExecuted(p.id, p.description);
    }

    // --- Labor Dignity ---
    function absorbWorker(address worker) public {
        directEmployment[worker] = true;
        equalRights[worker] = true;
        emit WorkerAbsorbed(worker, "Worker absorbed directly with equal rights.");
    }

    // --- Equal Rights ---
    function grantRights(address worker) public {
        equalRights[worker] = true;
        emit RightsGranted(worker, "Equal rights granted: no favoritism, no exploitation.");
    }

    // --- Workload Balance ---
    function recordWorkload(address worker, uint256 workload) public {
        workloadBalance[worker] = workload;
        emit WorkloadRecorded(worker, workload);
    }

    // --- Attendance & Incentives ---
    function recordAttendance(address worker) public {
        attendanceScore[worker] += 1;
        emit AttendanceRecorded(worker, attendanceScore[worker]);
    }

    // --- Employer Traits ---
    function declareTraits(address employer, string memory traits) public {
        employerTraits[employer] = traits;
        emit EmployerTraitsDeclared(employer, traits);
    }

    // --- Solidarity ---
    function declareSolidarity() public {
        emit SolidarityDeclared("Universal Justice Chain: workers, employers, communities united in dignity and resilience.");
    }
}
