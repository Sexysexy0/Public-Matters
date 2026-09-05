// SPDX-License-Identifier: PUBLIC-MATTERS-V1
pragma solidity 0.8.35;

contract FilipinnovationLedger {
    address public admin;
    bool public active;

    struct Innovator {
        address wallet;
        string name;
        string category;
        string company;
        string description;
        bool verified;
        uint256 timestamp;
        string ipfsHash;
    }

    struct Grant {
        uint256 id;
        address innovator;
        string projectName;
        uint256 amount;
        uint256 awardedDate;
        uint256 disbursedAmount;
        bool fullyDisbursed;
        string milestone;
        uint256 timestamp;
        string ipfsHash;
    }

    struct Commercialization {
        uint256 id;
        uint256 grantId;
        string productName;
        string market;
        uint256 revenue;
        bool launched;
        uint256 launchDate;
        string notes;
        uint256 timestamp;
        string ipfsHash;
    }

    struct ImpactEvent {
        uint256 id;
        string eventType;
        string description;
        uint256 score;
        uint256 timestamp;
        string ipfsHash;
        address proposer;
    }

    struct Vote {
        uint256 id;
        uint256 targetId;
        string targetType;
        uint256 votesFor;
        uint256 votesAgainst;
        uint256 startBlock;
        uint256 endBlock;
        bool executed;
        bool passed;
        address proposer;
    }

    Innovator[] public innovators;
    Grant[] public grants;
    Commercialization[] public commercializations;
    ImpactEvent[] public impactEvents;
    Vote[] public votes;

    mapping(address => bool) public isVerifiedInnovator;
    mapping(uint256 => mapping(address => bool)) public hasVoted;

    event InnovatorRegistered(address indexed wallet, string name, string category);
    event GrantAwarded(uint256 indexed id, address innovator, uint256 amount);
    event GrantDisbursed(uint256 indexed id, uint256 amount);
    event CommercializationLogged(uint256 indexed id, uint256 grantId, string productName);
    event ImpactEventLogged(uint256 indexed id, string eventType, uint256 score);
    event VoteCast(uint256 indexed id, address voter, bool support);
    event VoteExecuted(uint256 indexed id, bool passed);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    modifier whenActive() {
        require(active, "System paused");
        _;
    }

    modifier onlyVerifiedInnovator() {
        require(isVerifiedInnovator[msg.sender], "Not a verified innovator");
        _;
    }

    constructor() {
        admin = msg.sender;
        active = true;
    }

    // --- Innovator, Grant, Commercialization, ImpactEvent functions unchanged (timestamps kept for audit logs) ---

    function createVote(
        uint256 _targetId,
        string memory _targetType,
        uint256 _durationBlocks
    ) public onlyAdmin whenActive {
        require(_durationBlocks > 0, "Duration must be > 0");

        uint256 id = votes.length;
        votes.push(Vote({
            id: id,
            targetId: _targetId,
            targetType: _targetType,
            votesFor: 0,
            votesAgainst: 0,
            startBlock: block.number,
            endBlock: block.number + _durationBlocks,
            executed: false,
            passed: false,
            proposer: msg.sender
        }));
    }

    function castVote(uint256 _voteId, bool _support) public whenActive {
        require(_voteId < votes.length, "Invalid vote");
        require(!hasVoted[_voteId][msg.sender], "Already voted");
        require(block.number < votes[_voteId].endBlock, "Voting ended");

        hasVoted[_voteId][msg.sender] = true;
        if (_support) {
            votes[_voteId].votesFor++;
        } else {
            votes[_voteId].votesAgainst++;
        }

        emit VoteCast(_voteId, msg.sender, _support);
    }

    function executeVote(uint256 _voteId) public onlyAdmin whenActive {
        require(_voteId < votes.length, "Invalid vote");
        require(!votes[_voteId].executed, "Already executed");
        require(block.number >= votes[_voteId].endBlock, "Voting still active");

        votes[_voteId].executed = true;
        votes[_voteId].passed = votes[_voteId].votesFor > votes[_voteId].votesAgainst;

        emit VoteExecuted(_voteId, votes[_voteId].passed);
    }
}
