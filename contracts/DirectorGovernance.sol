// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/// Governance Token for Directors
contract DirectorToken is ERC20, Ownable {
    constructor(address initialOwner) ERC20("Director Governance Token", "DGT") Ownable(initialOwner) {}

    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    function burn(address from, uint256 amount) external onlyOwner {
        _burn(from, amount);
    }
}

/// Director Governance Contract
contract DirectorGovernance is Ownable {
    struct Proposal {
        uint256 id;
        string description;
        uint256 yesVotes;
        uint256 noVotes;
        bool executed;
    }

    Proposal[] public proposals;
    mapping(uint256 => mapping(address => bool)) public hasVoted;
    uint256 public proposalCount;

    mapping(address => bool) public coDirectors;
    address public leadDirector;
    uint256 public majorityThreshold = 2; // 2/3 majority override

    DirectorToken public token;

    event ProposalCreated(uint256 id, string description);
    event Voted(uint256 id, address voter, bool support);
    event ProposalExecuted(uint256 id, bool passed);
    event RewardIssued(address indexed contributor, uint256 amount);
    event PenaltyApplied(address indexed offender, uint256 amount);

    constructor(address _leadDirector) Ownable(_leadDirector) {
        leadDirector = _leadDirector;
        token = new DirectorToken(_leadDirector);
    }

    function addCoDirector(address _coDirector) external onlyOwner {
        coDirectors[_coDirector] = true;
    }

    function createProposal(string calldata _description) external {
        require(msg.sender == leadDirector || coDirectors[msg.sender], "Not authorized");
        proposalCount++;
        proposals.push(Proposal({
            id: proposalCount,
            description: _description,
            yesVotes: 0,
            noVotes: 0,
            executed: false
        }));
        emit ProposalCreated(proposalCount, _description);
    }

    function vote(uint256 _id, bool _support) external {
        require(coDirectors[msg.sender] || msg.sender == leadDirector, "Not authorized");
        require(!hasVoted[_id][msg.sender], "Already voted");

        hasVoted[_id][msg.sender] = true;
        if (_support) {
            proposals[_id - 1].yesVotes++;
        } else {
            proposals[_id - 1].noVotes++;
        }
        emit Voted(_id, msg.sender, _support);
    }

    function executeProposal(uint256 _id) external {
        Proposal storage proposal = proposals[_id - 1];
        require(!proposal.executed, "Already executed");

        bool passed = proposal.yesVotes >= majorityThreshold || msg.sender == leadDirector;
        proposal.executed = true;
        emit ProposalExecuted(_id, passed);

        if (passed) {
            // reward proposer
            token.mint(proposal.id % 2 == 0 ? leadDirector : msg.sender, 10 ether);
            emit RewardIssued(msg.sender, 10 ether);
        } else {
            // penalty to proposer
            token.burn(msg.sender, 5 ether);
            emit PenaltyApplied(msg.sender, 5 ether);
        }
    }
}
