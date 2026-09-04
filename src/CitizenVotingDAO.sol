// SPDX-License-Identifier: PUBLIC-MATTERS-V1
pragma solidity 0.8.35;

contract CitizenVotingDAO {
    address public admin;
    uint256 public proposalCount;

    struct Proposal {
        uint256 id;
        string title;
        string description;
        uint256 votesFor;
        uint256 votesAgainst;
        uint256 startTime;
        uint256 endTime;
        bool executed;
        bool passed;
        address proposer;
    }

    mapping(uint256 => Proposal) public proposals;
    mapping(uint256 => mapping(address => bool)) public hasVoted;
    mapping(address => bool) public isCitizen;

    event ProposalCreated(uint256 indexed id, string title);
    event VoteCast(uint256 indexed id, address voter, bool support);
    event ProposalExecuted(uint256 indexed id, bool passed);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    modifier onlyCitizen() {
        require(isCitizen[msg.sender], "Not a citizen");
        _;
    }

    constructor() {
        admin = msg.sender;
        isCitizen[msg.sender] = true;
        proposalCount = 0;
    }

    function registerCitizen(address _citizen) public onlyAdmin {
        isCitizen[_citizen] = true;
    }

    function createProposal(string memory _title, string memory _description, uint256 _votingDuration)
        public
        onlyCitizen
    {
        require(_votingDuration > 0, "Duration must be > 0");

        uint256 proposalId = proposalCount;
        proposals[proposalId] = Proposal({
            id: proposalId,
            title: _title,
            description: _description,
            votesFor: 0,
            votesAgainst: 0,
            startTime: block.timestamp,
            endTime: block.timestamp + _votingDuration,
            executed: false,
            passed: false,
            proposer: msg.sender
        });

        proposalCount++;
        emit ProposalCreated(proposalId, _title);
    }

    function vote(uint256 _proposalId, bool _support) public onlyCitizen {
        require(_proposalId < proposalCount, "Invalid proposal");
        require(!hasVoted[_proposalId][msg.sender], "Already voted");
        // forgefmt: disable-next-line
        // solhint-disable-next-line
        require(block.timestamp < proposals[_proposalId].endTime, "Voting ended");

        hasVoted[_proposalId][msg.sender] = true;
        if (_support) {
            proposals[_proposalId].votesFor++;
        } else {
            proposals[_proposalId].votesAgainst++;
        }

        emit VoteCast(_proposalId, msg.sender, _support);
    }

    function executeProposal(uint256 _proposalId) public onlyAdmin {
        require(_proposalId < proposalCount, "Invalid proposal");
        // forgefmt: disable-next-line
        // solhint-disable-next-line
        require(!proposals[_proposalId].executed, "Already executed");
        require(block.timestamp >= proposals[_proposalId].endTime, "Voting still active");

        proposals[_proposalId].executed = true;
        proposals[_proposalId].passed = proposals[_proposalId].votesFor > proposals[_proposalId].votesAgainst;

        emit ProposalExecuted(_proposalId, proposals[_proposalId].passed);
    }

    function getProposal(uint256 _proposalId) public view returns (Proposal memory) {
        require(_proposalId < proposalCount, "Invalid proposal");
        return proposals[_proposalId];
    }
}
