// SPDX-License-Identifier: PUBLIC-MATTERS-V1
pragma solidity 0.8.35;

contract CitizenVotingDAO {
    struct Proposal {
        uint256 id;
        string description;
        uint256 votesFor;
        uint256 votesAgainst;
        uint256 startBlock;
        uint256 endBlock;
        bool executed;
        bool passed;
    }

    Proposal[] public proposals;
    mapping(uint256 => mapping(address => bool)) public hasVoted;

    event ProposalCreated(uint256 indexed id, string description);
    event VoteCast(uint256 indexed id, address voter, bool support);
    event ProposalExecuted(uint256 indexed id, bool passed);

    function createProposal(string memory _description, uint256 _durationBlocks) public {
        require(_durationBlocks > 0, "Duration must be > 0");
        uint256 id = proposals.length;
        proposals.push(Proposal({
            id: id,
            description: _description,
            votesFor: 0,
            votesAgainst: 0,
            startBlock: block.number,
            endBlock: block.number + _durationBlocks,
            executed: false,
            passed: false
        }));
        emit ProposalCreated(id, _description);
    }

    function castVote(uint256 _id, bool _support) public {
        require(_id < proposals.length, "Invalid proposal");
        require(!hasVoted[_id][msg.sender], "Already voted");
        require(block.number < proposals[_id].endBlock, "Voting ended");

        hasVoted[_id][msg.sender] = true;
        if (_support) {
            proposals[_id].votesFor++;
        } else {
            proposals[_id].votesAgainst++;
        }
        emit VoteCast(_id, msg.sender, _support);
    }

    function executeProposal(uint256 _id) public {
        require(_id < proposals.length, "Invalid proposal");
        require(!proposals[_id].executed, "Already executed");
        require(block.number >= proposals[_id].endBlock, "Voting still active");

        proposals[_id].executed = true;
        proposals[_id].passed = proposals[_id].votesFor > proposals[_id].votesAgainst;
        emit ProposalExecuted(_id, proposals[_id].passed);
    }
}
