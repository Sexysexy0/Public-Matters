// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title TAP Governance Token
contract TAPToken is ERC20, Ownable {
    constructor() ERC20("Transparency Accountability Protocol Token", "TAPT") {}

    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    function burn(address from, uint256 amount) external onlyOwner {
        _burn(from, amount);
    }
}

/// @title Transparency & Accountability Protocol (TAP)
contract TAP is Ownable {
    TAPToken public token;

    struct Disclosure {
        address submitter;
        string content;
        uint256 timestamp;
    }

    struct Proposal {
        uint256 id;
        address proposer;
        string description;
        uint256 deadline;
        uint256 yesVotes;
        uint256 noVotes;
        bool executed;
    }

    Disclosure[] public disclosures;
    Proposal[] public proposals;
    mapping(uint256 => mapping(address => bool)) public hasVoted;

    uint256 public proposalCount;

    // --- Events ---
    event DisclosureLogged(address indexed submitter, string content, uint256 timestamp);
    event ProposalCreated(uint256 id, address proposer, string description, uint256 deadline);
    event Voted(uint256 id, address voter, bool support);
    event ProposalExecuted(uint256 id, bool passed);
    event PenaltyApplied(address indexed offender, uint256 amount);
    event RewardIssued(address indexed contributor, uint256 amount);

    constructor(address _token) {
        token = TAPToken(_token);
    }

    // --- Core Functions ---
    function logDisclosure(string calldata _content) external {
        disclosures.push(Disclosure(msg.sender, _content, block.timestamp));
        emit DisclosureLogged(msg.sender, _content, block.timestamp);
    }

    // --- Governance Voting ---
    function createProposal(string calldata _description, uint256 _duration) external {
        proposalCount++;
        proposals.push(Proposal({
            id: proposalCount,
            proposer: msg.sender,
            description: _description,
            deadline: block.timestamp + _duration,
            yesVotes: 0,
            noVotes: 0,
            executed: false
        }));
        emit ProposalCreated(proposalCount, msg.sender, _description, block.timestamp + _duration);
    }

    function vote(uint256 _id, bool _support) external {
        Proposal storage proposal = proposals[_id - 1];
        require(block.timestamp <= proposal.deadline, "Voting closed");
        require(!hasVoted[_id][msg.sender], "Already voted");

        uint256 voterStake = token.balanceOf(msg.sender);
        require(voterStake > 0, "No governance tokens");

        hasVoted[_id][msg.sender] = true;
        if (_support) {
            proposal.yesVotes += voterStake;
        } else {
            proposal.noVotes += voterStake;
        }
        emit Voted(_id, msg.sender, _support);
    }

    function executeProposal(uint256 _id) external {
        Proposal storage proposal = proposals[_id - 1];
        require(block.timestamp > proposal.deadline, "Voting not ended");
        require(!proposal.executed, "Already executed");

        bool passed = proposal.yesVotes > proposal.noVotes;
        proposal.executed = true;
        emit ProposalExecuted(_id, passed);
    }

    // --- Penalty & Reward ---
    function applyPenalty(address _offender, uint256 _amount) external onlyOwner {
        token.burn(_offender, _amount);
        emit PenaltyApplied(_offender, _amount);
    }

    function issueReward(address _contributor, uint256 _amount) external onlyOwner {
        token.mint(_contributor, _amount);
        emit RewardIssued(_contributor, _amount);
    }

    // --- View Helpers ---
    function getDisclosures() external view returns (Disclosure[] memory) {
        return disclosures;
    }

    function getProposals() external view returns (Proposal[] memory) {
        return proposals;
    }
}
