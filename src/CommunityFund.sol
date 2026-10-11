// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IUserTrust} from "./IUserTrust.sol";
import {ITrustIntegrator} from "./ITrustIntegrator.sol";

contract CommunityFund {
    address public steward;
    IUserTrust public userTrust;
    ITrustIntegrator public trustIntegrator;
    address public taxVault;

    struct Proposal {
        uint256 id;
        address proposer;
        string title;
        string description;
        uint256 amount;
        address recipient;
        uint256 votesFor;
        uint256 votesAgainst;
        bool executed;
        bool passed;
        uint256 createdAt;
        uint256 executedAt;
    }

    mapping(uint256 => Proposal) public proposals;
    mapping(uint256 => mapping(address => bool)) public hasVoted;
    mapping(address => uint256) public participationCount;
    uint256 public proposalCount;
    uint256 public minVoteThreshold = 1;
    uint256 public quorum = 1;

    event ProposalCreated(uint256 id, address proposer, string title, uint256 amount);
    event Voted(uint256 id, address voter, bool support, uint256 trustReward);
    event ProposalExecuted(uint256 id, address recipient, uint256 amount);

    modifier onlySteward() {
        require(msg.sender == steward, "Only steward");
        _;
    }

    constructor(address _userTrust, address _trustIntegrator, address _taxVault) {
        steward = msg.sender;
        userTrust = IUserTrust(_userTrust);
        trustIntegrator = ITrustIntegrator(_trustIntegrator);
        taxVault = _taxVault;
    }

    function createProposal(string calldata title, string calldata description, uint256 amount, address recipient)
        external
    {
        require(amount > 0, "Amount must be > 0");
        require(recipient != address(0), "Invalid recipient");
        require(userTrust.getScore(msg.sender) >= minVoteThreshold, "Trust too low to propose");

        proposalCount++;
        proposals[proposalCount] = Proposal({
            id: proposalCount,
            proposer: msg.sender,
            title: title,
            description: description,
            amount: amount,
            recipient: recipient,
            votesFor: 0,
            votesAgainst: 0,
            executed: false,
            passed: false,
            createdAt: block.timestamp,
            executedAt: 0
        });

        emit ProposalCreated(proposalCount, msg.sender, title, amount);
    }

    function vote(uint256 proposalId, bool support) external {
        require(proposalId > 0 && proposalId <= proposalCount, "Invalid proposal");
        require(!proposals[proposalId].executed, "Already executed");
        require(!hasVoted[proposalId][msg.sender], "Already voted");
        require(userTrust.getScore(msg.sender) >= minVoteThreshold, "Trust too low to vote");

        hasVoted[proposalId][msg.sender] = true;
        uint256 weight = userTrust.getScore(msg.sender);
        if (weight == 0) weight = 1;

        Proposal storage p = proposals[proposalId];
        if (support) {
            p.votesFor += weight;
        } else {
            p.votesAgainst += weight;
        }

        // Reward voter with trust points (1 point per vote)
        uint256 trustReward = 1;
        trustIntegrator.logPositiveAction(string(abi.encodePacked("Voted on proposal: ", p.title)), trustReward);

        participationCount[msg.sender]++;

        emit Voted(proposalId, msg.sender, support, trustReward);

        // Auto-pass if quorum met and votesFor > votesAgainst
        if ((p.votesFor + p.votesAgainst) >= quorum && p.votesFor > p.votesAgainst) {
            p.passed = true;
        }
    }

    function executeProposal(uint256 proposalId) external {
        Proposal storage p = proposals[proposalId];
        require(p.passed, "Proposal not passed");
        require(!p.executed, "Already executed");
        require(msg.sender == steward || msg.sender == address(this), "Not authorized");

        (bool success,) = taxVault.call(
            abi.encodeWithSignature("allocateFunds(address,uint256,string)", p.recipient, p.amount, p.title)
        );
        require(success, "Allocation failed");

        trustIntegrator.logPositiveAction(string(abi.encodePacked("Fund allocation: ", p.title)), 5);

        p.executed = true;
        p.executedAt = block.timestamp;
        emit ProposalExecuted(proposalId, p.recipient, p.amount);
    }

    function setMinVoteThreshold(uint256 _new) external onlySteward {
        minVoteThreshold = _new;
    }

    function setQuorum(uint256 _new) external onlySteward {
        quorum = _new;
    }

    function setTaxVault(address _new) external onlySteward {
        taxVault = _new;
    }

    function setUserTrust(address _new) external onlySteward {
        userTrust = IUserTrust(_new);
    }

    function setTrustIntegrator(address _new) external onlySteward {
        trustIntegrator = ITrustIntegrator(_new);
    }
}
